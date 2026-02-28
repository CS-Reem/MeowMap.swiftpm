//
//  PlaceMapView.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import SwiftUI
import MapKit

struct PlaceMapView: UIViewRepresentable {

    @Binding var region: MKCoordinateRegion
    let annotations: [PlaceAnnotation]
    let overlays: [MKOverlay]
    var onTap: (CLLocationCoordinate2D) -> Void

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> MKMapView {
        let map        = MKMapView()
        map.delegate   = context.coordinator
        map.showsUserLocation = false
        map.setRegion(region, animated: false)

        let tap = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(MapCoordinator.handleTap(_:))
        )
        map.addGestureRecognizer(tap)

        context.coordinator.mapView = map
        context.coordinator.onTap   = onTap
        return map
    }

    func updateUIView(_ map: MKMapView, context: Context) {
        context.coordinator.onTap = onTap
        map.setRegion(region, animated: true)
        updateAnnotations(on: map)
        updateOverlays(on: map)
    }

    func makeCoordinator() -> MapCoordinator { MapCoordinator() }

    // MARK: - Private helpers

    private func updateAnnotations(on map: MKMapView) {
        let current = map.annotations.compactMap { $0 as? PlaceAnnotation }
        guard current.count != annotations.count else { return }
        map.removeAnnotations(current)
        map.addAnnotations(annotations)
    }

    private func updateOverlays(on map: MKMapView) {
        let currentCircle = map.overlays.first as? MKCircle
        let newCircle     = overlays.first as? MKCircle

        let radiusChanged = currentCircle?.radius != newCircle?.radius
        let centerChanged: Bool = {
            guard let c = currentCircle, let n = newCircle else { return true }
            return c.coordinate.latitude  != n.coordinate.latitude
                || c.coordinate.longitude != n.coordinate.longitude
        }()

        guard radiusChanged || centerChanged else { return }
        map.removeOverlays(map.overlays)
        map.addOverlays(overlays)
    }
}
