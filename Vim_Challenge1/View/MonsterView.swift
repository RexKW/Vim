
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
    @State private var selectedDetent: PresentationDetent = .height(300)
    
    @Environment(\.modelContext) private var modelContext
    @Query private var monsters : [Monster]
    //@Query(sort: \Monster.name) private var monsters :[Monster]
    //health bar sesuaikan dengan kal latest
    //button back 
    //predict berdasarkan status first jika done maka next
    
//    let monster: [Monster] = [
//            Monster(name: "Rex Mohawk", hp: 0, image: "Rex", deadImage: "", status: "In Progress"),
//            Monster(name: "AdamDevil", hp: 0, image: "AdamDevil", deadImage: "", status: "Locked"),
//            Monster(name: "Jojomblo", hp: 0, image: "Jojomblo", deadImage: "", status: "Locked"),
//            Monster(name: "Unknown", hp: 0, image: "UnknownMonster", deadImage: "", status: "Coming Soon")
//
//    ]
    
    var body: some View {
        
        
        VStack{
            NavigationStack(){
                ZStack{
                    //monster including background
                    Image(workoutVM.progressMonster?.image ?? "Unknow Image").resizable().frame(width: 300, height: 300)
                    VStack{
                        VStack{
                            //monster name
                            Text(workoutVM.progressMonster?.name ?? "Unknown Monster" ).fontWeight(.heavy).padding(.bottom,-5)
                            HealthBar(value: workoutVM.progressMonster?.currentHp ?? 0, maxValue: workoutVM.progressMonster?.hp ?? 0)
                                .onAppear{
                                    print(workoutVM.progressMonster?.currentHp ?? 0)
                                }
                        }
                        
                        Spacer()
                        //the workout button
                        if(!isWorkout){
                            Button(action:{
                                isWorkout = true
                            }){
                                Text("Attack").foregroundColor(.white).padding(.horizontal, 90).padding(.vertical, 10)
                            }.buttonStyle(BorderedProminentButtonStyle()).padding(.bottom,60)
                        }
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        //session section
                        VStack{
                            Text("Session 1")
                            Text("1 Apr")
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
                //sheet for workout
            }.sheet(isPresented: $isWorkout){
                WorkoutSheetView( currentDetent: $selectedDetent)
                    .presentationBackgroundInteraction(.enabled)
                    .interactiveDismissDisabled()
                    .presentationDetents(
                        [.height(200), .height(400)],
                        selection: $selectedDetent)
            }
            //sheet for journey
            .sheet(isPresented: $isJourney){
//                JourneyView()
            }
            .background(.white)
        }
        .onAppear {
            workoutVM.modelContext = modelContext
            workoutVM.setMonster(monsters)
            workoutVM.setupHealthKit()
        }
        
    }
}

func HealthBar(value: Double, maxValue: Double) -> some View {
    ZStack{
        ZStack(alignment: .leading){
            //This is just for the red border
            Rectangle()
                .frame(width: 250, height: 40)
                .cornerRadius(50)
                .foregroundColor(.red)
            
            //This is for the white backdrop of the health
            ZStack(alignment: .leading){
                ZStack(alignment:.center){
                    Rectangle()
                        .frame(width: totalBarWidth, height: 30)
                        .cornerRadius(50)
                        .foregroundColor(.white)
                    Text("\(value) Kcal").foregroundColor(Color.red).fontWeight(Font.Weight.black).padding(.leading, 20)
                }

                ZStack(alignment:.center){
                    
                    //This is the green Healthbar to show shrinking
                    Text("\(value) Kcal" ).foregroundColor(Color.white).fontWeight(Font.Weight.black).padding(.leading, 20).frame(width: 245, height: 30).background(Color.green).mask(
                        HStack {
                            Rectangle()
                                .frame(width: CGFloat(value) / CGFloat(maxValue) * 245) //Edit the size here to shrink
                            Spacer(minLength: 0)
                        }
                    )
                }.clipShape(Rectangle()).frame(width: 245)
                
                // Bar Hijau dengan Masking
                ZStack {
                    Text("\(latesthp)").foregroundColor(.white).fontWeight(.black).font(.system(size: 12))
                        .frame(width: totalBarWidth, height: 30)
                        .background(Color.green)
                        .mask(
                            HStack(spacing: 0) {
                                Rectangle().frame(width: dynamicWidth)
                                Spacer(minLength: 0)
                            }
                        )
                }
            }
            .clipShape(Capsule())
            .padding(.leading, 5) // Memberikan jarak agar tidak tertutup hati
        }
    }
    .animation(.interactiveSpring(), value: dynamicWidth)
}

#Preview {
    MonsterView()
        .environmentObject(WorkoutViewModel())
}

