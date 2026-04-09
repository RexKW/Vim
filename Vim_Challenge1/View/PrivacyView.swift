//
//  PrivacyView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct PrivacyView: View {
    @Binding var isFinished: Bool
    @State private var isPresentedContinue: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image(systemName: "lock.heart.fill")
                .resizable()
                .frame(width: 150, height: 130)
                .scaledToFit()
                .foregroundColor(.brightRed)
            Text("Allow Access to Your Calorie Data")
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.bottom, -5)
            Text("This app requests permission to read your calorie data from HealthKit to help you track and analyze your exercises.")
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            VStack(alignment: .leading, spacing: 15) {
                privacyInfo(icon: "bolt.slash.fill", desc: "Your data is being processed locally on this device.", height: 25)
                privacyInfo(icon: "person.3.sequence.fill", desc: "VIM does not share your data with any third party.", height: 16)
                privacyInfo(icon: "icloud.slash.fill", desc: "VIM operates in offline use only, with no external server storage.", height: 18)
                privacyInfo(icon: "figure.strengthtraining.functional", desc: "Your calorie data will be used on battles to defeat the monsters.", height: 25)
            }
            VStack {
                Button(action: {
                    isPresentedContinue = true
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity) // Ini yang membuat tombol melebar ke kanan-kiri
                        .padding(.vertical, 12)     // Ini membuat tombol lebih "gemuk" (atas-bawah)
                }
                .buttonStyle(.borderedProminent)
                .tint(.darkBlue)
                .padding(.top, 60)
                Button(action: {
                    dismiss()
                }) {
                    Text("Not Now")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity) // Ini yang membuat tombol melebar ke kanan-kiri
                        .padding(.vertical, 12)     // Ini membuat tombol lebih "gemuk" (atas-bawah)
                        .foregroundColor(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray .opacity(0.25))
            }
        }
        .padding(.horizontal, 40)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isPresentedContinue) {
            CalorieTargetView()
        }
    }
}

#Preview {
    PrivacyView(isFinished: .constant(false))
}

func privacyInfo(icon: String, desc: String, height: Int) -> some View {
    HStack {
        Image(systemName: icon)
            .resizable()
            .frame(width: 20, height: CGFloat(height))
            .scaledToFit()
            .foregroundColor(.brightRed)
        Text(desc)
            .font(.system(size: 10, weight: .regular))
            .padding(.horizontal, 0)
    }
}
