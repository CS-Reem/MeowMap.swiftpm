//
//  SwiftUIView.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 07/09/1447 AH.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()

            VStack {
                Spacer(minLength: 90)

                VStack(spacing: 6) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)

                    Image("findYourLostCat")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 240)
                        .padding(.top, 2)

                }

                Spacer()
            }
        }
    }
}

#Preview {
    SplashView()
}
