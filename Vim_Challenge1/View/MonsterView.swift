//
//  MonsterView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI
import SwiftData

struct MonsterView: View {
    @State private var isWorkout: Bool = false
    @State private var isJourney: Bool = false
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Monster.name) private var monsters :[Monster]
    
    
    var body: some View {
        
        
        VStack{
            NavigationStack(){
                ZStack{
                    //monster including background
                    Image("Monster").resizable().scaledToFit().frame(width: .infinity).padding(.bottom, -200)
                    VStack{
                        VStack{
                            //monster name
                            Text("Rex").fontWeight(.heavy).padding(.bottom,-5)
                            HealthBar(value: 100)
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
            }.sheet(isPresented: $isWorkout, ){
                WorkoutSheetView()
                    . presentationBackgroundInteraction(. enabled)
                    .presentationDetents([.height(300), .height(600)])
            }
            //sheet for journey
            .sheet(isPresented: $isJourney){
                JourneyView()
            }
            .background(.white)
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
                    Text("300 HP").foregroundColor(Color.red).fontWeight(Font.Weight.black)
                }

                ZStack(alignment:.center){
                    
                    //This is the green Healthbar to show shrinking
                    Text("300 HP").foregroundColor(Color.white).fontWeight(Font.Weight.black).frame(width: 245, height: 30).background(Color.green).mask(
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
}

