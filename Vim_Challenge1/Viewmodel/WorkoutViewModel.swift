//
//  WorkoutViewmodel.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import Foundation
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var timeElapsed: Double = 0
    @Published var isTimerRunning: Bool = false
    
    private var timer: Timer?
    
    /// This is for starting the timer when the workout sheet appear
    func startTimer(){
        guard !isTimerRunning else { return }
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in self.timeElapsed += 0.01}
    }
    
    // making the time Elapsed format to 00.00,00
    var formattedTime: String {
        let minutes = Int(timeElapsed) / 60
        let seconds = Int(timeElapsed) % 60
        let fractional = Int((timeElapsed.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d.%02d,%02d", minutes, seconds, fractional)
    }
    
    /// This is for pausing the timer
    func pauseTimer(){
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    /// This is for reseting the timer
    func resetTimer(){
        pauseTimer()
        timeElapsed = 0
    }
}
