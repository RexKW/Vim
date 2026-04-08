//
//  JourneyView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct JourneyView: View {
    
    //status ada apa aja?
    let dummyMonsters = [
        Monster(name: "Rex Mohawk", hp: 0, image: "Rex", deadImage: "", status: "In Progress"),
        Monster(name: "AdamDevil", hp: 0, image: "AdamDevil", deadImage: "", status: "Locked"),
        Monster(name: "Jojomblo", hp: 0, image: "Jojomblo", deadImage: "", status: "Locked"),
        Monster(name: "Unknown", hp: 0, image: "UnknownMonster", deadImage: "", status: "Coming Soon"),
        
    ]
    
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
                    
                    
                    LazyVGrid(columns: journeyColumns, spacing: 20) {
                        ForEach(dummyMonsters, id: \.self) { monster in
                            
                            VStack(alignment: .center, spacing: 0) {
                                
                                Image(monster.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 120)
                                    .offset(y: 30)
                                    .clipShape(.rect)
                                    .grayscale(monster.status != "In Progress" ? 1.0 : 0.0)
                                    .padding(.top, 10)
                                
                                Divider()
                                    .frame(height: 1)
                                
                                VStack(spacing: 5){
                                    Text(monster.status == "In Progress" ? monster.name : (monster.status == "Coming Soon" ? "Coming Soon.." : "???"))
                                        .fontWeight(monster.status == "In Progress" ? .bold : .regular)
                                        .font(.subheadline)
                                        .padding(.top, 10)
                                    
                                    Text(monster.status != "Coming Soon" ? monster.status : "")
                                        .padding(2)
                                        .padding(.horizontal, 4)
                                        .font(.caption2)
                                        .foregroundStyle(monster.status == "In Progress" || monster.status == "Completed" ? Color.green : Color.gray)
                                        .background(
                                            (monster.status == "In Progress" || monster.status == "Completed")
                                            ? Color.green.opacity(0.1)
                                            : (monster.status == "Coming Soon" ? Color.clear : Color.gray.opacity(0.1)))
                                        .cornerRadius(4)
                                    
                                    
                                }
                                .padding(.bottom, 10)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(monster.status == "In Progress" || monster.status == "Completed" ? Color.white : Color.gray.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                            //                    .background(.red)
                        }
                    }
                    .padding(.horizontal,30)
                    
                    
                }
                
                Spacer()
            }
            .scrollDisabled(true)

        }

    }
}



#Preview {
    JourneyView()
}
