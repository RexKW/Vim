//
//  WorkoutViewModel+Extension.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 09/04/26.
//

import Foundation
import HealthKit

extension WorkoutViewModel: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Not needed if you don't track events
    }
    
    
    // 1.
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder,
                       didCollectDataOf collectedTypes: Set<HKSampleType>) {
        
        // 2.
        for sampleType in collectedTypes {
            guard let quantityType = sampleType as? HKQuantityType else { continue }
            
            // 3.
            let statistics = workoutBuilder.statistics(for: quantityType)
            
            // 4.
            if let stats = statistics {
                updateMetrics(for: stats)
            }
        }
    }
}

extension WorkoutViewModel: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession,
                       didChangeTo toState: HKWorkoutSessionState,
                       from fromState: HKWorkoutSessionState,
                       date: Date) {
        // 1.
        if toState == .stopped,
           let builder = workoutBuilder {
            Task {
                do {
                    // 2.
                    try await builder.endCollection(at: date)
                    
                    // 3.
                    let savedWorkout = try await builder.finishWorkout()
                    
                    // 4.
                    workoutSession.end()
                    
                    // 5.
                    await MainActor.run {
                        currentState = .finished
                        print("Workout saved to HealthKit: \(String(describing: savedWorkout))")
                    }
                } catch {
                    print("Failed to save workout: \(error.localizedDescription)")
                    await MainActor.run {
                        currentState = .idle
                    }
                }
            }
        }
    }
    
    // 6.
    func workoutSession(_ workoutSession: HKWorkoutSession,
                       didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }
}
