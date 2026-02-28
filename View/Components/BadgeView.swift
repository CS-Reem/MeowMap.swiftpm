//
//  BadgeView.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import SwiftUI

struct BadgeView: View {

    let text: String

    var body: some View {
        Text(text)
            .font(.footnote)
            .fontWeight(.semibold)
            .padding(10)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
    }
}
