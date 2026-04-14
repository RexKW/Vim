//
//  MonsterView+Extension.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 14/04/26.
//

import Foundation
import SwiftUI

extension MonsterView{
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
                            .frame(width: 245, height: 30)
                            .cornerRadius(50)
                            .foregroundColor(.white)
                        Text("\(Int(value)) Kcal").foregroundColor(Color.red).fontWeight(Font.Weight.black).padding(.leading, 20)
                    }
                    
                    ZStack(alignment:.center){
                        
                        //This is the green Healthbar to show shrinking
                        Text("\(Int(value)) Kcal" ).foregroundColor(Color.white).fontWeight(Font.Weight.black).padding(.leading, 20).frame(width: 245, height: 30).background(Color.green).mask(
                            HStack {
                                Rectangle()
                                    .frame(width: Double(value) / Double(maxValue) * 245) //Edit the size here to shrink
                                Spacer(minLength: 0)
                            }
                        )
                    }.clipShape(Rectangle()).frame(width: 245)
                    
                    
                }
                .clipShape(Capsule())
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
        .animation(.interactiveSpring(), value: CGFloat(value) / CGFloat(maxValue) * 245)
    }
}
