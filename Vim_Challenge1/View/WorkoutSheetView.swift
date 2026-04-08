//
//  WorkoutView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct WorkoutSheetView: View {
    @State var calBurnedSheet: Bool = false
    @State private var isPaused = false
    @Binding var currentDetent: PresentationDetent
    
    var body: some View {
        VStack{
            HStack {
                VStack (alignment: .leading, spacing: 10){
                    //all element in VStack will be left aligned
                    
                    //calorie burned
                    Text("0 Kcal")
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(.vibrantOrange)
                    
                    //stopwatch
                    Text("00.00,00")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 30)
                
                //making the element layout dynamic
                Spacer()
                
                //play and pause button
                Button(action: {
                    isPaused.toggle()
                }) {
                    //change symbol based on isPaused status
                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color.white)
                        .padding(30)
                        .background(Color.vibrantOrange)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 30)
            }
            .padding(.vertical, 10)
            
            if currentDetent == .height(400){
                HStack{
                    //exercise recommendation
                    VStack (alignment: .leading, spacing: 5){
                        Text("Ways to Defeat Rex ⚔️")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.vertical, 5)
                        Text("Walk  : ~50 Kcal / 15 min (Light Attack)")
                        Text("Run    : ~150 Kcal / 15 min (Heavy Attack)")
                        Text("Stairs : ~220 Kcal / 15 min (Critical Hit)")
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                .transition(.opacity.combined(with:.move(edge: .bottom)))
                
                //end session button in sheet
                VStack (alignment: .center) {
                    Button("End Session", systemImage: "xmark"){
                        
                    }
                    .frame(width: 300, height: 10)
                    .foregroundColor(Color.white)
                    .padding(20)
                    .background(Color.vibrantRed)
                    .cornerRadius(100)
                }
                .transition(.opacity.combined(with:.move(edge: .bottom)))
                .padding()
            }
        }
        .padding(.top, 20)
        .animation(.spring(), value: currentDetent)
    }
}

#Preview {
    WorkoutSheetView(currentDetent: .constant(.height(400)))
}
