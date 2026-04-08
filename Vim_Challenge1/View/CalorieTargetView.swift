//
//  CalorieTargetView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

//
//  JourneyDetailView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct CalorieTargetView: View {
    @State private var select_index = 0 ;
    @State private var value: Int = 500
    var body: some View {
        VStack(){
            Text("Initial target Calories")
                .font(.system(size: 22))
                .bold()
                .padding(.bottom, 9)
            
            Text("""
            Everybody starts somewhere! Chose 
            the target caloriest that suits your ability 
            and daily routine
            """)
                .font(.system(size: 17))
                .padding(.bottom, 41)
                .multilineTextAlignment(.center)
            
            
            
            Picker("Difficulty", selection: $select_index) {
                Text("Easy").tag(0)
                Text("Medium").tag(1)
                Text("Hard").tag(2)
            }
            .onChange(of: select_index){
                oldValue,
                newValue in
                switch newValue {
                case 0:
                    value = 500
                case 1:
                    value = 750
                case 2:
                    value = 1000
                default:
                    break
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: 250)
            .padding(.bottom,20)
            .scaleEffect(1.2)
//            Rectangle()
//                .fill(Color.blue)
//                .frame(width: 350, height: 50)
//                .cornerRadius(25)
//                .padding(.bottom,63)
//            
//            Rectangle()
//                .fill(Color.blue)
//                .frame(width: 300, height: 100)
//                .cornerRadius(20)
//                .padding(.bottom,14)
            HStack {
                Button {
                    if value > 450 {
                        value -= 10
                    }
                    else{
                        value = 450
                    }
                } label: {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 46, height: 42)
                        .overlay(
                            Image(systemName: "minus")
                                .font(.title2)
                                .foregroundStyle(.black)
                        )
                }
                
                VStack(spacing: 2){
                    Text("\(value)")
                        .font(.system(size: 60, weight: .bold))
                    Text("Kcal")
                        .font(.system(size: 22, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                
                Button {
                    value += 50
                } label: {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 46, height: 42)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(.black)
                        )
                }
            }
            .frame(maxWidth: 270)
            .padding(.bottom, 40)
            
            var steps: Int {
                Int(Double(value)/0.04)
            }
            
            Text("""
            This is equivalent to :
            - \(Text("\(steps) steps").bold()) on the run.
            - \(Text("\(steps / 2) stairs steps.").bold())
            """)
            .padding(.bottom, 150)
            
            Text("""
            The target calorie can be completed
            anytime, but \(Text("2 weeks of inactivity").bold())
            will result in a \(Text("reset").bold())
            """)
            .font(.system(size: 12))
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
    CalorieTargetView()}
