//
//  CongratsView.swift
//  Vim_Challenge1
//
//  Created by I Putu Josanda Putra Wena on 09/04/26.
//

import SwiftUI

struct CongratsView: View {
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Congratulations! 🎉")
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)
                Text("You defeated the monster! What's next for your goal?")
                    .padding(.top,-1)
                    .multilineTextAlignment(.center)
                Image(.deadRex)
                    .resizable()
                    .frame(width: 180, height: 200)
                    .padding(.top, 20)
                
                Button (action: {
                    isPresented = true
                }){
                    Text("Set Calories")
                        .fontWeight(.semibold)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 110)
                }
                .buttonStyle(.borderedProminent)
                .tint(.darkBlue)
                .padding(.top, 60)
            }
            .navigationDestination(isPresented: $isPresented) {
                CalorieTargetView()
            }
        }
    }
}

#Preview {
    CongratsView()
        .environmentObject(WorkoutViewModel())
}
