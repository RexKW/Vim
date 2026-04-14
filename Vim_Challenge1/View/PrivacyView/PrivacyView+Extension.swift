//
//  PrivacyView+Extension.swift
//  Vim_Challenge1
//
//  Created by Rex Kenny Wirasantoso on 14/04/26.
//

import SwiftUI

extension PrivacyView {
    func privacyInfo(icon: String, desc: String, height: Int) -> some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: CGFloat(height))
                .scaledToFit()
                .foregroundColor(.brightRed)
            Text(desc)
                .font(.system(size: 10, weight: .regular))
                .padding(.horizontal, 0)
        }
    }

}
