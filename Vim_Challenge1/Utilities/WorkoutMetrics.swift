//
//  WorkoutMetrics.swift
//  HealthTrackTest
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import Foundation

struct WorkoutMetrics: Codable {
    var elapsedTime: TimeInterval = 0
    var heartRate: Double = 0
    var isHeartRateAvailable:Bool = false
    var totalCalories: Double = 0
    var totalDistance: Double = 0
    
    mutating func reset() {
        self.elapsedTime = 0
        self.heartRate = 0
        self.isHeartRateAvailable = false
        self.totalCalories = 0
        self.totalDistance = 0
    }
}
