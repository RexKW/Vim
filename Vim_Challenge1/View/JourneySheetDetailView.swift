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
        Text("Hello World")
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
