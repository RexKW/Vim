//
//  Vim_Challenge1App.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI
import SwiftData

@main
struct Vim_Challenge1App: App {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutViewModel)
                .modelContainer(for: [Monster.self, User.self, Session.self])
        }
    }
}
