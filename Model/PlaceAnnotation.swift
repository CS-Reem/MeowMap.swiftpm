//
//  PlaceAnnotation.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import MapKit

final class PlaceAnnotation: NSObject, MKAnnotation, @unchecked Sendable {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let category: PlaceCategory

    init(mapItem: MKMapItem, category: PlaceCategory) {
        self.title    = mapItem.name
        self.subtitle = mapItem.placemark.title
        self.coordinate = mapItem.placemark.coordinate
        self.category = category
    }
}
