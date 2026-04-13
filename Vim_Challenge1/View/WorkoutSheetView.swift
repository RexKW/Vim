//
//  WorkoutView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI
import HealthKit

struct WorkoutSheetView: View {

    @Binding var currentDetent: PresentationDetent
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack() {
            VStack{
                HStack {
                    VStack (alignment: .leading, spacing: 10){
                        //all element in VStack will be left aligned
                        
                        //calorie burned
                        Text(String(format: "%.1f Kcal", workoutVM.metrics.totalCalories))
                            .font(.system(size: 45))
                            .fontWeight(.bold)
                            .foregroundColor(.vibrantOrange)
                        
                        //stopwatch
                        Text(workoutVM.formattedTime(timeElapsed: workoutVM.metrics.elapsedTime))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 30)
                    
                    //making the element layout dynamic
                    Spacer()
                    
                    //play and pause button
                    Button(action: {
                        if(workoutVM.currentState == .paused){
                            workoutVM.resumeWorkout()
                        }else{
                            workoutVM.pauseWorkout()
                        }
                    }) {
                        //change symbol based on isPaused status
                        Image(systemName: workoutVM.currentState == .paused ? "play.fill" : "pause.fill")
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
                            Task {
                                workoutVM.endWorkout()
                                dismiss()
                            }
                            
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
            .task {
                await workoutVM.startWorkout(activity: .running, location: .outdoor)
            }
            
        }
    }
}

#Preview {
    WorkoutSheetView(currentDetent: .constant(.height(400)))
        .environmentObject(WorkoutViewModel())
}
