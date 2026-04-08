//
//  Monster.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import Foundation
import SwiftData

@Model
class Monster{
    var name: String
    var status: String
    var hp: Int
    var sessions: [Session]
    
    init(name: String,  hp: Int) {
        self.name = name
        self.status = "In Progress"
        self.hp = hp
        self.sessions = []
    }
}
