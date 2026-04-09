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
    var image: String
    var deadImage: String
    
    init(name: String,  hp: Int, image:String, deadImage:String, status:String) {
        self.name = name
        self.status = status
        self.hp = hp
        self.image = image
        self.deadImage = deadImage
        self.sessions = []
    }
}
