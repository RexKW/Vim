//
//  JourneyDetailView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct JourneySheetDetailView: View {
    var body: some View {
        VStack(){
            Text("Initial target Calories")
                .font(.system(size: 22))
                .bold()
                .padding(.bottom, 9)
            
            Text("Everybody starts somewhere! Chose the target caloriest that suits your ability and daily routine")
                .font(.system(size: 17))
                .padding(.bottom, 41)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 350, height: 50)
                .cornerRadius(25)
                .padding(.bottom,63)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 300, height: 100)
                .cornerRadius(20)
                .padding(.bottom,14)
            Text("""
            This is equivalent to :
            - \(Text("8 K Steps").bold()) on the run.
            - \(Text("5K stairs steps").bold())
            """)
            .padding(.bottom,100)
            
            Text("""
            The target calorie can be completed
            anytime, but \(Text("2 weeks of inactivity").bold())
            will result in a \(Text("reset").bold())
            """)
            .foregroundColor(Color("Color_CalorieTargetView_Text"))
            .multilineTextAlignment(.center)
            .padding(.bottom,18)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 272, height: 48)
                .cornerRadius(24)
                .overlay(
                    Text("Set Target")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 18))
                )
        }
    }
}

#Preview {
    JourneySheetDetailView()
}
