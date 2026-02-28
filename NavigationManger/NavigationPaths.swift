//
//  NavigationPaths.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import SwiftUI
struct NavigationPathsView: View {
    
    @StateObject var appStateManager = AppStateManager()
    
    var body: some View {
        
        ZStack {
            
            switch appStateManager.state {
                
            case .splash:
                SplashView()
                
                
            case .contentView:
                ContentView()
                
           
            }
        }
        .animation(.easeOut(duration: 0.5), value: appStateManager.state)
        .environmentObject(appStateManager)
    }
}
enum AppState {
    case splash
    case contentView
    
    
}
