//
//  SplashScreenView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct SplashScreenView: View {
    @Binding var isFinished: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("vimLogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Welcome to")
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)
                Text("VIM")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.darkBlue)
                Text("where your exercise journey to getting fit begins!")
                    .font(.system(size: 12, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                    .padding(.top, -5)
                VStack(alignment: .leading, spacing: 15) {
                    ///ganti icon
                    HStack {
                        Image(systemName: "target")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFit()
                            .foregroundColor(.darkBlue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Monster Battle")
                                .font(.system(size: 12, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 9)
                            Text("Set your own challenge! Choose your calorie target to define the monster's health bar.")
                                .font(.system(size: 10, weight: .regular))
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding(.horizontal, 45)
                    ///ganti icon
                    HStack {
                        Image(systemName: "figure.run")
                            .resizable()
                            .frame(width: 40, height: 45)
                            .scaledToFit()
                            .foregroundColor(.darkBlue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Track Your Progress")
                                .font(.system(size: 12, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 9)
                            Text("View your battle strikes in Journey. Collect badges as proof of your undefeated streak!")
                                .font(.system(size: 10, weight: .regular))
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding(.horizontal, 45)
                    ///ganti icon
                    HStack {
                        Image(systemName: "trophy.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .scaledToFit()
                            .foregroundColor(.darkBlue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Attack With Exercise")
                                .font(.system(size: 12, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 9)
                            Text("Set your own challenge! Choose your calorie target to define the monster's health bar.")
                                .font(.system(size: 10, weight: .regular))
                                .padding(.horizontal, 10)
                        }
                        
                    }
                    .padding(.horizontal, 45)
                    
                }
                
                Spacer()
                
                NavigationLink(destination: PrivacyView(isFinished: $isFinished)) {
                    ZStack {
                        Capsule()
                            .foregroundColor(.darkBlue)
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 45)
                    .frame(height: 60)
                }
                .padding(.bottom, 45)
            }
            .padding(.top, 120)
        }
    }
}

#Preview {
    SplashScreenView(isFinished: .constant(false))
}
