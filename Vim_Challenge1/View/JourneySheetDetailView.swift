//
//  JourneyDetailView.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 07/04/26.
//

import SwiftUI

struct JourneySheetDetailView: View {
    let monster: Monster
    
    var body: some View {
        VStack {
            Text("Detail for \(monster.name)")
        }
        .navigationTitle(monster.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    JourneySheetDetailView(
        monster: Monster(
            name: "Rex Mohawk",
            hp: 0,
            image: "Rex",
            deadImage: "",
            status: "In Progress"
        )
    )
}
