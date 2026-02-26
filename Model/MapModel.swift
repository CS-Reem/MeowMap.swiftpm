//
//  MapModel.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 08/09/1447 AH.
//

import Foundation
import CoreLocation

#if canImport(SwiftData)
import SwiftData
#endif

// MARK: - iOS 17+ SwiftData model
#if canImport(SwiftData)
@available(iOS 17, *)
@Model
class UserLocation {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var name: String // Optional: Location name or tag

    init(location: CLLocation, name: String = "") {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
        self.name = name
    }

    // Computed property to turn raw data back into a usable CLLocation
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
#endif

// MARK: - Fallback model for iOS < 17 (no SwiftData persistence)
// This provides the same API surface used by the app code without relying on SwiftData.
#if !canImport(SwiftData)
class UserLocation {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var name: String // Optional: Location name or tag

    init(location: CLLocation, name: String = "") {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.timestamp = location.timestamp
        self.name = name
    }

    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
#endif

