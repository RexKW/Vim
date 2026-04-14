//
//  MonsterCardView.swift
//  Vim_Challenge1
//
//  Created by Sharon Tan on 09/04/26.
//

import SwiftUI

struct MonsterCardView: View {
    
    let monster: Monster
    
    var body: some View {
        //card
        VStack(alignment: .center, spacing: 0) {
            
            //image monster
            Image(monster.image)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 120)
                .offset(y: 30)
                .clipShape(.rect)
                .grayscale(monster.status == "Locked" || monster.status == "Coming Soon" ? 1.0 : 0.0)
                .padding(.top, 10)
            
            Divider()
                .frame(height: 1)
            
            VStack(spacing: 5){
                Text(monster.status == "In Progress" || monster.status == "Dead" ? monster.name : (monster.status == "Coming Soon" ? "Coming Soon.." : "???"))
                    .fontWeight(monster.status == "In Progress" ? .bold : .regular)
                    .font(.subheadline)
                    .padding(.top, 10)
                
                Text(monster.status != "Coming Soon" ? monster.status : "")
                    .padding(2)
                    .padding(.horizontal, 4)
                    .font(.caption2)
                    .foregroundStyle(monster.status == "In Progress" ? Color.green : Color.gray)
                    .background(
                        (monster.status == "In Progress" || monster.status == "Dead")
                        ? Color.green.opacity(0.1)
                        : (monster.status == "Coming Soon" ? Color.clear : Color.gray.opacity(0.1)))
                    .cornerRadius(4)
                
                
            }
            .padding(.bottom, 10)
            
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(monster.status == "In Progress" || monster.status == "Dead" ? Color.white : Color.gray.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        
    }
    
}

#Preview {
    MonsterCardView(
        monster: Monster(
            id: 0, 
            name: "Rex Mohawk",
            hp: 0,
            image: "Rex",
            deadImage: "",
            status: "Dead"
        )
    )
}
