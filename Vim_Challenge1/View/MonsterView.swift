
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
    
    private var proggresmonster : Monster?{
        monsters.first(where: {$0.status != "Done"})
    }
    var body: some View {
        
        
        VStack{
            NavigationStack(){
                ZStack{
                    //monster including background
                    Image(proggresmonster!.image).resizable().scaledToFit().frame(maxWidth: .infinity).padding(.bottom, -200)
                    VStack{
                        VStack{
                            //monster name
                            Text(proggresmonster!.name).fontWeight(.heavy).padding(.bottom,-5)
                            HealthBar(latesthp: 100, hpmax: proggresmonster!.hp) //latest hp adalah kalori yang dibakar
                            //HealthBar(value: proggresmonster!.hp)
                                .onAppear{
                                    print(proggresmonster!.hp)
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
            }.sheet(isPresented: $isWorkout, ){
                WorkoutSheetView()
                    . presentationBackgroundInteraction(. enabled)
                    .presentationDetents([.height(300), .height(600)])
            }
            //sheet for journey
            .sheet(isPresented: $isJourney){
//                JourneyView()
            }
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
    }
}

func HealthBar(latesthp: Int, hpmax: Int) -> some View {
    let totalBarWidth: CGFloat = 200 // Kita perkecil sedikit agar totalnya tetap 250-an
    let percentage = max(0, min(CGFloat(latesthp) / CGFloat(max(1, hpmax)), 1.0))
    let dynamicWidth = totalBarWidth * percentage

    return HStack(spacing: -25) { // Gunakan spacing negatif agar hati "menggigit" sedikit bagian bar
        
        // 1. Ikon Hati (Diletakkan paling depan/kiri)
        ZStack {
            Rectangle()
                .frame(width: 50, height: 40)
                .foregroundColor(.red)
                .cornerRadius(50)
            
            Image(systemName: "heart.fill")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
        .zIndex(1) // Memastikan hati berada di atas bar secara visual
        
        // 2. Kontainer Bar Kesehatan
        ZStack(alignment: .leading) {
            // Border Merah
            Rectangle()
                .frame(width: totalBarWidth + 10, height: 40)
                .cornerRadius(50)
                .foregroundColor(.red)
            
            // Isi Bar (Putih & Hijau)
            ZStack(alignment: .leading) {
                // Background Putih
                ZStack {
                    Rectangle()
                        .frame(width: totalBarWidth, height: 30)
                        .cornerRadius(50)
                        .foregroundColor(.white)
                    
                    Text("\(latesthp) / \(hpmax) Kcal").foregroundColor(.red).fontWeight(.black).font(.system(size: 12))
                }
                
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
}
