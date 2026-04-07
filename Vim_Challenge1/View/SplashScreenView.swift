//
//  SplashScreenView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            ///Ini nanti diganti icon
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.darkBlue)
                .frame(width: 150, height: 150)
                .padding(10)
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
            VStack(alignment: .leading) {
                ///ganti icon
                HStack {
                    Circle()
                        .fill(.darkBlue)
                        .frame(width: 60, height: 60)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Monster Battle")
                            .font(.system(size: 12, weight: .bold))
                            .multilineTextAlignment(.leading)
                        Text("Set your own challenge! Choose your calorie target to define the monster's health bar.")
                            .font(.system(size: 10, weight: .regular))
                    }
                }
                ///ganti icon
                HStack {
                    Circle()
                        .fill(.darkBlue)
                        .frame(width: 60, height: 60)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Track Your Progress")
                            .font(.system(size: 12, weight: .bold))
                            .multilineTextAlignment(.leading)
                        Text("View your battle strikes in Journey. Collect badges as proof of your undefeated streak!")
                            .font(.system(size: 10, weight: .regular))
                    }
                }
                ///ganti icon
                HStack {
                    Circle()
                        .fill(.darkBlue)
                        .frame(width: 60, height: 60)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Attack With Exercise")
                            .font(.system(size: 12, weight: .bold))
                            .multilineTextAlignment(.leading)
                        Text("Set your own challenge! Choose your calorie target to define the monster's health bar.")
                            .font(.system(size: 10, weight: .regular))
                    }
                    
            }
                Button(action: {
                    // Tambahkan aksi di sini
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity) // Ini yang membuat tombol melebar ke kanan-kiri
                        .padding(.vertical, 12)     // Ini membuat tombol lebih "gemuk" (atas-bawah)
                }
                .buttonStyle(.borderedProminent)
                .tint(.darkBlue)
                .padding(.top, 120)
            }
        }
        // padding untuk vstacknya
        .padding(.horizontal, 45)
    }
}

#Preview {
    SplashScreenView()
}
