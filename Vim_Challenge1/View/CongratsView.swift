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
                Spacer()
                VStack(alignment: .center, spacing: 10){
                    Text("Sheesh! Victory 🎉")
                        .font(.system(size: 34, weight: .bold))
                        .multilineTextAlignment(.center)
                    Text("You absolutely crushed that monster and finished your exercise. That’s how a champ does it!")
                        .multilineTextAlignment(.center)
                    
                    Image(.deadRex)
                        .resizable()
                        .frame(width: 180, height: 200)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                VStack{
                    Text("Ready to keep this \(Text("momentum").foregroundColor(.vibrantOrange).bold()) going for your next goal?")                .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .padding(.top, 50)
                        .padding(.horizontal, 32)
                    
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
                    .padding(.top, 10)
                }
                .padding(.bottom, 10)
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
