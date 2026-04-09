
//
//  MonsterView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI
import SwiftData

struct MonsterView: View {
    @EnvironmentObject var workoutVM: WorkoutViewModel
    @State private var isWorkout: Bool = false
    @State private var isJourney: Bool = false
    @State private var selectedDetent: PresentationDetent = .height(300)
    
    @Environment(\.modelContext) private var modelContext
    @Query private var monsters : [Monster]
    //@Query(sort: \Monster.name) private var monsters :[Monster]
    //predict berdasarkan status first jika done maka next
    
//    let monster: [Monster] = [
//            Monster(name: "Rex Mohawk", hp: 0, image: "Rex", deadImage: "", status: "In Progress"),
//            Monster(name: "AdamDevil", hp: 0, image: "AdamDevil", deadImage: "", status: "Locked"),
//            Monster(name: "Jojomblo", hp: 0, image: "Jojomblo", deadImage: "", status: "Locked"),
//            Monster(name: "Unknown", hp: 0, image: "UnknownMonster", deadImage: "", status: "Coming Soon")
//
//    ]
    
    private var proggresmonster : Monster{
        monsters.first(where: {$0.status != "Done"}) ?? Monster(name: "Rex Mohawk", hp: 500, image: "Rex", deadImage: "", status: "In Progress")
    }
    var body: some View {
        
        
        VStack{
            NavigationStack(){
                ZStack{
                    //monster including background
                    Image(proggresmonster.image).resizable().frame(width: 300, height: 300)
                    VStack{
                        VStack{
                            //monster name
                            Text(proggresmonster.name ).fontWeight(.heavy).padding(.bottom,-5)
                            HealthBar(value: proggresmonster.hp)
                                .onAppear{
                                    print(proggresmonster.hp)
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
                JourneyView(isJourney: $isJourney, monster: monsters)
            }
            .background(.white)
        }
        .onAppear {
            workoutVM.setupHealthKit()
        }
        
    }
}

func HealthBar(value: Int) -> some View {
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
                        .frame(width: 245, height: 30)
                        .cornerRadius(50)
                        .foregroundColor(.white)
                    Text(String(value)).foregroundColor(Color.red).fontWeight(Font.Weight.black)
                }

                ZStack(alignment:.center){
                    
                    //This is the green Healthbar to show shrinking
                    Text(String(value)).foregroundColor(Color.white).fontWeight(Font.Weight.black).frame(width: 245, height: 30).background(Color.green).mask(
                        HStack {
                            Rectangle()
                                .frame(width:120) //Edit the size here to shrink
                            Spacer(minLength: 0)
                        }
                    )
                }.clipShape(Rectangle()).frame(width: 245)
                
            }.clipShape(Capsule())

            //This is the leftside heart
            Rectangle()
                .frame(width: 60, height: 40)
                .foregroundColor(Color.red)
                .cornerRadius(50)
            Image(systemName: "heart.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
                .frame(width: 60, height: 50)
                .cornerRadius(14)
        }


    }
}

#Preview {
    MonsterView()
        .environmentObject(WorkoutViewModel())
}

