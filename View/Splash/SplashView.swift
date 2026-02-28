//
//  SwiftUIView.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 07/09/1447 AH.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    @State private var scale = 0.6
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
                        .scaleEffect(scale)

                    Image("findYourLostCat")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 240)
                        .padding(.top, 2)
                        .scaleEffect(scale)

                }

                Spacer()
            }
        }
        .onAppear {
                        withAnimation(.easeInOut(duration: 1)) {
                            scale = 1
                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                            appStateManager.contentView()
//                        }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                appStateManager.state = .contentView
            }

                    }
    }
}

#Preview {
    SplashView()
}
