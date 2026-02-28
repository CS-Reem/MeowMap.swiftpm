//
//  AppStateManger.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import Combine
import Foundation
@MainActor
class AppStateManager: ObservableObject {
    @Published var state: AppState = .splash

}
