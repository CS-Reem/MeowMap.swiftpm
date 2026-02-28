//
//  MapCoordinator.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import MapKit

final class MapCoordinator: NSObject, MKMapViewDelegate {

    var onTap: ((CLLocationCoordinate2D) -> Void)?
    weak var mapView: MKMapView?
    private var centerPin: MKPointAnnotation?

    // MARK: - Tap Handler

    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let map = mapView else { return }
        let point      = gesture.location(in: map)
        let coordinate = map.convert(point, toCoordinateFrom: map)

        if let old = centerPin { map.removeAnnotation(old) }

        let pin       = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title      = ""
        map.addAnnotation(pin)
        centerPin = pin

        onTap?(coordinate)
    }

    // MARK: - MKMapViewDelegate

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let point = annotation as? MKPointAnnotation {
            return makePinView(for: point, in: mapView, id: "CenterPin", icon: "cat.fill", color: .systemPurple)
        }
        if let place = annotation as? PlaceAnnotation {
            return makePinView(for: place, in: mapView, id: "PlacePin-\(place.category.rawValue)",
                               icon: place.category.icon, color: place.category.color)
        }
        return nil
    }

//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        guard let circle = overlay as? MKCircle else { return MKOverlayRenderer() }
//        let renderer          = MKCircleRenderer(circle: circle)
//        renderer.fillColor    = UIColor.systemBlue.withAlphaComponent(0.1)
//        renderer.strokeColor  = .systemBlue
//        renderer.lineWidth    = 2
//        return renderer
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circle = overlay as? MKCircle else { return MKOverlayRenderer() }
        let renderer          = MKCircleRenderer(circle: circle)
        renderer.fillColor    = UIColor(named: "appColor")?.withAlphaComponent(0.1)
        renderer.strokeColor  = UIColor(named: "appColor")
        renderer.lineWidth    = 2
        return renderer
    }

    // MARK: - Private

    private func makePinView(
        for annotation: MKAnnotation,
        in mapView: MKMapView,
        id: String,
        icon: String,
        color: UIColor
    ) -> MKMarkerAnnotationView {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKMarkerAnnotationView
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
        view.annotation    = annotation
        view.glyphImage    = UIImage(systemName: icon)
        view.markerTintColor = color
        view.canShowCallout  = true
        return view
    }
}
