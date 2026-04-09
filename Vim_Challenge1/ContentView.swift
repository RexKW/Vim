//
//  ContentView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
    var body: some View {
        if hasCompletedOnboarding == true {
            MonsterView()
        }
        else {
            SplashScreenView(isFinished: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutViewModel())
}
