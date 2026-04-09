//
//  JourneyView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct JourneyView: View {
    
    //status ada apa aja?
//    let dummyMonsters = [
//        Monster(name: "Rex Mohawk", hp: 0, image: "Rex", deadImage: "", status: "In Progress"),
//        Monster(name: "AdamDevil", hp: 0, image: "AdamDevil", deadImage: "", status: "Locked"),
//        Monster(name: "Jojomblo", hp: 0, image: "Jojomblo", deadImage: "", status: "Locked"),
//        Monster(name: "Unknown", hp: 0, image: "UnknownMonster", deadImage: "", status: "Coming Soon"),
//        
//    ]
    let monster: [Monster]
    
    let journeyColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                
                VStack(alignment: .center, spacing: 32) {
                    Text("For every monster you defeat unlocks one new Monster!\nYou can check your sessions and progresses here.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .padding(.top, 20)
                    
                    //collection
                    LazyVGrid(columns: journeyColumns, spacing: 20) {
                        ForEach(monster, id: \.self) { monster in
                            
                            NavigationLink{
                                JourneySheetDetailView(monster: monster)
                            }
                            label : {
                                
                            }
                        }
                        .padding(.horizontal,30)
                        
                        
                    }
                    
                    Spacer()
                }
            }
            .scrollDisabled(true)
            .navigationTitle("Journey")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}



#Preview {
    JourneyView(monster: [
        Monster(name: "Rex Mohawk", hp: 0, image: "Rex", deadImage: "", status: "In Progress"),
        Monster(name: "AdamDevil", hp: 0, image: "AdamDevil", deadImage: "", status: "Locked"),
        Monster(name: "Jojomblo", hp: 0, image: "Jojomblo", deadImage: "", status: "Locked"),
        Monster(name: "Unknown", hp: 0, image: "UnknownMonster", deadImage: "", status: "Coming Soon")
    ])
}
