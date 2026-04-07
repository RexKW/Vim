//
//  Session.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import Foundation
import SwiftData

@Model
class Session{
    var name: String
    var timeStamp: Date
    var duration: Int
    var caloriesBurned: Int
    
    init(name: String, timeStamp: Date, duration: Int, caloriesBurned: Int) {
        self.name = name
        self.timeStamp = timeStamp
        self.duration = duration
        self.caloriesBurned = caloriesBurned
    }
}
