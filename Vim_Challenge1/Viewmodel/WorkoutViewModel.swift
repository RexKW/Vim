//
//  WorkoutViewmodel.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import Foundation
import Combine
import HealthKit

class WorkoutViewModel: NSObject ,ObservableObject {
    @Published var timeElapsed: Double = 0
    @Published var isTimerRunning: Bool = false
    @Published var currentState: WorkoutState = .idle
    @Published var metrics = WorkoutMetrics()
    private var pauseStartDate: Date?
    private var totalPausedTime: TimeInterval = 0
    
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
                self.currentState = .finished
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
                    self.metrics.totalCalories = caloriesValue
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
