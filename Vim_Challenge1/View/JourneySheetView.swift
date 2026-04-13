//
//  JourneyView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct JourneyView: View {
    @Binding var isJourney: Bool
    
    let monster: [Monster]
    
    let journeyColumns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
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
                                JourneySheetDetailView(isJourney: $isJourney, monster: monster)
                            }
                            label : {
                                MonsterCardView(monster: monster)
                            }
                            .buttonStyle(.plain)
                            .disabled(monster.status == "Locked" || monster.status == "Coming Soon")
                            
                        }
                        
                    }
                    .padding(.horizontal,16)

                    
                    Spacer()
                }
            }
            .scrollDisabled(true)
            .navigationTitle("Journey")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isJourney = false
                    } label: {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
        
    }
}



#Preview {
    JourneyView(
        isJourney: .constant(true),
                monster: [
                    Monster(name: "Rex Mohawk", hp: 0, image: "Rex", deadImage: "", status: "In Progress"),
                    Monster(name: "AdamDevil", hp: 0, image: "AdamDevil", deadImage: "", status: "Locked"),
                    Monster(name: "Jojomblo", hp: 0, image: "Jojomblo", deadImage: "", status: "Locked"),
                    Monster(name: "Unknown", hp: 0, image: "UnknownMonster", deadImage: "", status: "Coming Soon")
                ])
}
