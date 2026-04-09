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
    var hp: Double
    var currentHp: Double
    var sessions: [Session]
    var image: String
    var deadImage: String
    
    init(name: String,  hp: Double, image:String, deadImage:String, status:String) {
        self.name = name
        self.status = status
        self.hp = hp
        self.currentHp = hp
        self.image = image
        self.deadImage = deadImage
        self.sessions = []
    }
}
