//
//  ContentView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        CalorieTargetView()
    }
}

#Preview {
    ContentView()
        .environmentObject(WorkoutViewModel())
}
