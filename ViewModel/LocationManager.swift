import SwiftUI
import MapKit
import CoreLocation

// MARK: - Location Manager

@MainActor
class LocationManager: NSObject, ObservableObject, @MainActor CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var permissionDenied = false  // ← track if user denied
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        //Defult location set to Riyadh
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        //Zoom: Smaller numbers = more zoomed in. 0.05 is roughly a city-level zoom
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        print("📍 Requesting location permission...")
        manager.requestWhenInUseAuthorization() // ← triggers the popup
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // No need for DispatchQueue.main.async anymore
        userLocation = location.coordinate
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        manager.stopUpdatingLocation()
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if (manager.authorizationStatus == .authorizedWhenInUse ||
//           manager.authorizationStatus == .authorizedAlways) {
//            manager.startUpdatingLocation()
//            print("location access allowed")
//        }
//        else{print("location access denied")}
//    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                permissionDenied = false
                manager.startUpdatingLocation()
            case .denied, .restricted:
                permissionDenied = true  // ← user said no
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            @unknown default:
                break
            }
        }
}
