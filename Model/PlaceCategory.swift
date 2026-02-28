//
//  PlaceCategory.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import SwiftUI
import MapKit

enum PlaceCategory: String, CaseIterable, Identifiable {
    case restaurant = "Restaurants"
    case mosque     = "Mosques"
    case park       = "Parks"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .restaurant: return "fork.knife"
        case .mosque:     return "building.columns.fill"
        case .park:       return "leaf.fill"
        }
    }

    var color: UIColor {
        switch self {
        case .restaurant: return .systemOrange
        case .mosque:     return .systemGreen
        case .park:       return .systemTeal
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .restaurant: return .orange
        case .mosque:     return .green
        case .park:       return .teal
        }
    }

    var filter: MKPointOfInterestFilter? {
        switch self {
        case .restaurant:
            return MKPointOfInterestFilter(including: [.restaurant, .cafe, .bakery, .brewery, .foodMarket])
        case .mosque:
            return nil
        case .park:
            return MKPointOfInterestFilter(including: [.park, .nationalPark, .beach, .marina])
        }
    }

    var naturalQuery: String? {
        switch self {
        case .mosque: return "mosque"
        default:      return nil
        }
    }
}
