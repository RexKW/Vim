
//
//  MonsterView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct MonsterView: View {
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @State private var isWorkout: Bool = false
    @State private var isJourney: Bool = false
    @State private var isFloating = false
    @State private var selectedDetent: PresentationDetent = .height(300)
    @State private var fightMotivationText: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var monsters : [Monster]
    
    var fightMotivation: [String] = [
        "Unleash your first strike! Start moving to deal damage ⚔️",
        "Ignite the flames! Burn calories to weaken the beast 🔥",
        "Don't let the enemy breathe, charge now! 🏃‍♂️",
        "Your sweat is your ammunition. Load up and attack! 💥",
        "Initiate the hunt! Every step is a blow to the monster 👺",
        "Convert your burned calories into a lethal blow. Start the session! ❤️‍🔥",
        "The battle begins with a single step. Strike hard! ⚡️"
    ]
    
    
    var body: some View {
        VStack{
            NavigationStack(path: $workoutVM.navigationPath){
                ZStack{
                    //monster including background
                    Image("Backdrop").resizable().edgesIgnoringSafeArea(.all)
                    Image(workoutVM.progressMonster?.image ?? "Unknow Image").resizable().frame(width: 300, height: 400).offset(x: 0, y: isFloating ? 0 : 40)
                    //                        .animation(
                    //                            .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                    //                            value: isFloating
                    //                        )
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                                isFloating = true
                            }
                        }
                    VStack{
                        VStack{
                            //monster name
                            Text(workoutVM.progressMonster?.name ?? "Unknown Monster" ).fontWeight(.heavy).padding(.bottom,-5).foregroundStyle(.white)
                            HealthBar(value: workoutVM.progressMonster?.currentHp ?? 0, maxValue: workoutVM.progressMonster?.hp ?? 0)
                                .onAppear{
                                    print(workoutVM.progressMonster?.currentHp ?? 0)
                                }
                            
                            //MARK: - Fight "motivation" Text
                            Text(fightMotivationText)
                                .multilineTextAlignment(.center)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 50)
                                .onAppear {
                                    fightMotivationText = fightMotivation.randomElement() ?? "Fight!"
                                }
                            
                            
                        }
                        
                        Spacer()
                        //the workout button
                        if(!isWorkout){
                            Button(action:{
                                isWorkout = true
                            }){
                                Text("Attack").foregroundColor(.white).padding(.horizontal, 90).padding(.vertical, 10)
                            }.buttonStyle(BorderedProminentButtonStyle()).padding(.bottom,60).tint(.darkBlue)
                        }
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        //session section
                        VStack{
                            Text("Session \(((workoutVM.progressMonster?.sessions.count ?? 0) + 1))").foregroundStyle(.white).fontWeight(.bold)
                            
                            Text(Date.now.formatted(date: .abbreviated, time: .omitted)).foregroundColor(.white)
                        }.fixedSize()
                    }.sharedBackgroundVisibility(.hidden)
                    //journey button
                    ToolbarItem(placement: .primaryAction){
                        Button(action:{
                            isJourney = true
                        }){
                            Image(systemName: "shield.fill").foregroundColor(Color(.white))
                        }.buttonStyle(.borderedProminent)
                            .tint(.blue)
                    }
                }
                .toolbar(isWorkout ? .hidden : .visible)
                //sheet for workout
            }.sheet(isPresented: $isWorkout){
                WorkoutSheetView( currentDetent: $selectedDetent)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                    .presentationDetents(
                        [.height(200), .height(400)],
                        selection: $selectedDetent)
                    .onChange(of: workoutVM.isDead) { died in
                        if died {
                            isWorkout = false
                        }
                    }
            }
            .fullScreenCover(isPresented: $workoutVM.isDead) {
                    CongratsView()
            }
            //sheet for journey
            .sheet(isPresented: $isJourney){
                JourneySheetView(isJourney: $isJourney, monster: monsters)
            }
            .background(.white)
        }
        .onAppear {
            workoutVM.modelContext = modelContext
            workoutVM.setMonster(monsters)
            //            workoutVM.setupHealthKit()
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    MonsterView()
        .environmentObject(WorkoutViewModel())
}

