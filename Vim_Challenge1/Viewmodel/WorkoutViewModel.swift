//
//  WorkoutViewmodel.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import Foundation
import Combine
import HealthKit
import SwiftUI
import _SwiftData_SwiftUI

class WorkoutViewModel: NSObject ,ObservableObject {
    @Published var timeElapsed: Double = 0
    @Published var isTimerRunning: Bool = false
    @Published var currentState: WorkoutState = .idle
    @Published var metrics = WorkoutMetrics()
    @Published var progressMonster: Monster?
    @Published var navigationPath = NavigationPath()
    
    private var calorieDamageBucket: Double = 0
    private var lastCalories: Double = 0
    var modelContext: ModelContext?
    
    
    func setMonster(_ monsters: [Monster]) {
        self.progressMonster = monsters.first(where: { $0.status == "In Progress" })
        // So only in progress monster on MonsterView
    }
    
    private var pauseStartDate: Date?
    private var totalPausedTime: TimeInterval = 0
    private var totalPausedCalories: Double = 0
    
    private let healthStore = HKHealthStore()
    
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    
    
    
    private var startDate: Date?
    private var elapsedTimeTimer: Timer?
    
    // making the time Elapsed format to 00.00,00
    func formattedTime(timeElapsed: TimeInterval) -> String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        let fractional = Int((timeElapsed.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d.%02d,%02d", minutes, seconds, fractional)
    }
    
    //checks if healthkit is available
    func isHealthAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    //request permission to user for pulling data from health kit. This will be asked in the privacy view later on
    private func requestHealthKitPermission(){
        guard let hr = HKObjectType.quantityType(forIdentifier: .heartRate),
              let kcal = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let dist = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        else {
            return
        }
        let read: Set = [hr, kcal, dist, HKObjectType.workoutType()]
        let write: Set = [kcal, dist, HKObjectType.workoutType()]
        
        healthStore.requestAuthorization(toShare: write, read: read) { (success, error) in
            if let error  {
                print("HealthKit Authorization Failed: \(error.localizedDescription)")
            }else{
                print(success ? "Healthkit access granted" : "Healthkit access denied")
            }
        }
        
    }
    
    //this is to setup the health kit
    func setupHealthKit() {
        guard isHealthAvailable() else {
            print("HealthKit not available")
            return
        }
        requestHealthKitPermission()
    }
    
    // Starts a new workout session with the specified activity type
    @MainActor
    func startWorkout(activity: HKWorkoutActivityType = .running, location: HKWorkoutSessionLocationType = .outdoor) async {
        guard workoutSession == nil, currentState == .idle else {
            print("Workout already in progress or starting")
            return
        }
        // 1.
        metrics.reset()
        currentState = .preparing
        
        do {
            // 2.
            let workoutConfig = HKWorkoutConfiguration()
            workoutConfig.activityType = activity
            workoutConfig.locationType = location
            
            // 3.
            let workoutInstance = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfig)
            workoutInstance.delegate = self
            
            // 4.
            let dataBuilder = workoutInstance.associatedWorkoutBuilder()
            dataBuilder.delegate = self
            
            // 5.
            dataBuilder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfig)
            
            // 6.
            workoutSession = workoutInstance
            workoutBuilder = dataBuilder
            
            // 7.
            workoutInstance.prepare()
            
            
            // 8.
            let workoutStartTime = Date()
            startDate = workoutStartTime
            workoutInstance.startActivity(with: workoutStartTime)
            
            // 9.
            try await dataBuilder.beginCollection(at: workoutStartTime)
            
            // 10.
            currentState = .active
            startElapsedTimeTimer()
            
            print("Workout started successfully")
            
        } catch {
            print("Failed to start workout: \(error.localizedDescription)")
            currentState = .idle
        }
    }
    
    
    // 3.
    private func startElapsedTimeTimer() {
        elapsedTimeTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let startDate = self.startDate else { return }
            let rawTime = Date().timeIntervalSince(startDate)
            self.metrics.elapsedTime = rawTime - totalPausedTime
        }
    }
    
    // 4.
    private func stopElapsedTimeTimer() {
        elapsedTimeTimer?.invalidate()
        elapsedTimeTimer = nil
    }
    
    // 1.
    func pauseWorkout() {
        workoutSession?.pause()
        currentState = .paused
        pauseStartDate = Date()
        stopElapsedTimeTimer()
        print("Workout paused")
    }
    
    // 2.
    func resumeWorkout() {
        workoutSession?.resume()
        currentState = .active
        if let pauseStartDate{
            totalPausedTime += Date().timeIntervalSince(pauseStartDate)
            
            self.pauseStartDate = nil
        }
        self.metrics.totalCalories -= totalPausedCalories
        totalPausedCalories = 0
        self.calorieDamageBucket = 0
        startElapsedTimeTimer()
        print("Workout resumed")
    }
    
    // 3.
    func endWorkout() {
        guard let session = workoutSession, let builder = workoutBuilder else { return }
        
        // Stop activity timer
        stopElapsedTimeTimer()
        
        // Stop the session
        session.stopActivity(with: Date())
        
        // End the session properly
        session.end()
        
        progressMonster!.sessions.append(Session(name: "Session \(progressMonster!.sessions.count + 1)", timeStamp: Date.now, duration: Int(self.metrics.elapsedTime), caloriesBurned: Double(self.metrics.totalCalories)))
        
        Task {
            do {
                // Finish collecting data
                try await builder.endCollection(at: Date())
                _ = try await builder.finishWorkout()
                
                print("Workout saved to HealthKit")
            } catch {
                print("Failed to finish workout: \(error.localizedDescription)")
            }
            
            // Clean up
            await MainActor.run {
                self.workoutSession = nil
                self.workoutBuilder = nil
                self.totalPausedTime = 0
                self.totalPausedCalories = 0
                self.calorieDamageBucket = 0
                self.currentState = .idle
                self.metrics.reset()
            }
        }
    }
    
    func updateMetrics(for statistics: HKStatistics){
        DispatchQueue.main.async {
            switch statistics.quantityType {
                // 2.
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                if let heartRateValue = statistics.mostRecentQuantity()?.doubleValue(for: .count().unitDivided(by: .minute())) {
                    self.metrics.heartRate = heartRateValue
                    self.metrics.isHeartRateAvailable = true
                }
                
                // 3.
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                if let caloriesValue = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) {
                    
                    // Ignore downward recalibrations
                    guard caloriesValue > self.lastCalories else { return }

                    let rawDelta = caloriesValue - self.lastCalories
                    self.lastCalories = caloriesValue

                    if self.currentState != .paused {
                        self.metrics.totalCalories = caloriesValue
                        
                        // 1. Add the tiny trickle of calories to our bucket
                        self.calorieDamageBucket += rawDelta
                        
                        // 2. Set your attack threshold (e.g., 1 full kcal = 1 attack)
                        
                        //MARK: HAPUS 1000 JADI 1.0
                        let caloriesPerAttack = 1.0 // 👈 Tweak this! Higher = less frequent, bigger attacks
                        
                        // 3. Only deal damage when the bucket is full
                        if self.calorieDamageBucket >= caloriesPerAttack {
                            if let monster = self.progressMonster {
                                
                                // Deal chunk damage (1 kcal * 5 damage = 5 total damage per strike)
                                let damage = Double(caloriesPerAttack)
                                print("💥 BOOM! Monster took \(damage) damage!")
                                
                                monster.currentHp = max(0, monster.currentHp - damage)
                                
                                if monster.currentHp <= 0 {
                                    self.killMonster(monster: monster)
                                }
                                
                                do {
                                    try self.modelContext?.save()
                                } catch {
                                    print("Save failed:", error)
                                }
                                self.objectWillChange.send()
                                
                                // 4. Empty the bucket (but keep the remainder for the next attack)
                                self.calorieDamageBucket -= caloriesPerAttack
                            }
                        }
                    }
                }
                
                // 4.
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                if let distanceValue = statistics.sumQuantity()?.doubleValue(for: .meter()) {
                    self.metrics.totalDistance = distanceValue
                }
                
            default:
                break
            }
        }
        
    }
    
    @MainActor
    /// func to kill monster
    func killMonster(monster: Monster){
        endWorkout()
        monster.status = "Dead"
        navigationPath.append("CongratsView")
    }
    
    //    /// This is for starting the timer when the workout sheet appear
    //    func startTimer(){
    //        guard !isTimerRunning else { return }
    //        isTimerRunning = true
    //        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in self.timeElapsed += 0.01}
    //    }
    //
    
    //
    //    /// This is for pausing the timer
    //    func pauseTimer(){
    //        timer?.invalidate()
    //        timer = nil
    //        isTimerRunning = false
    //    }
    //
    //    /// This is for reseting the timer
    //    func resetTimer(){
    //        pauseTimer()
    //        timeElapsed = 0
    //    }
}

