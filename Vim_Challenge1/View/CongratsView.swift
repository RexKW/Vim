//
//  CongratsView.swift
//  Vim_Challenge1
//
//  Created by I Putu Josanda Putra Wena on 09/04/26.
//

import SwiftUI

struct CongratsView: View {
    var body: some View {
        NavigationStack {
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
            
            NavigationLink(destination: CalorieTargetView()) {
                ZStack {
                    Capsule()
                        .foregroundColor(.darkBlue)
                    
                    Text("Set Calories")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(.white)
                }
                .frame(height: 60)
                .padding(.horizontal, 45)
                .padding(.top, 50)
                
            }
        }
    }
}

#Preview {
    CongratsView()
}
