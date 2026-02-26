//import SwiftUI
//import MapKit
//
//struct MapView: View {
////    // Region used for iOS 16 and earlier fallback, and as a starting point for iOS 17+
////    @State private var region = MKCoordinateRegion(
////        center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090), // Apple Park
////        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
////    )
////
////    // Toggle to show user's location; requires NSLocationWhenInUseUsageDescription in Info.plist and permission flow elsewhere.
////    @State private var showsUserLocation: Bool = false
////
//    var body: some View {
        
//        Group {
//            if #available(iOS 17.0, *) {
//                // iOS 17+ path using MapCameraPosition
//                Map(position: .constant(.region(region)), interactionModes: .all) {
//                    if showsUserLocation {
//                        UserAnnotation()
//                    }
//                }
//                .mapControls {
//                    MapUserLocationButton()
//                    MapCompass()
//                    MapScaleView()
//                }
//            } else {
//                // iOS 16 and earlier fallback using coordinateRegion binding
//                Map(coordinateRegion: $region, showsUserLocation: showsUserLocation)
//                    .overlay(alignment: .topTrailing) {
//                        // Basic compass alternative for older iOS (MapCompass is iOS 17+)
//                        CompassFallback()
//                            .padding(8)
//                    }
//            }
//        }
//        .ignoresSafeArea(edges: .top)
//        .onAppear {
//            // You can programmatically adjust the camera/region here if needed.
//        }
//    }
//}
//
//// Simple compass-like fallback for iOS < 17 where MapCompass isn't available.
//private struct CompassFallback: View {
//    var body: some View {
//        Image(systemName: "location.north.line")
//            .imageScale(.large)
//            .padding(8)
//            .background(.thinMaterial, in: Circle())
//            .accessibilityLabel("Compass")
//    }
//}
////
//#Preview {
//    MapView()
//}
//
//


//
//  mm.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 09/09/1447 AH.
//
// MARK: - Content View
import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var selectedPin: IdentifiableCoordinate?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // MARK: Map
            Map(coordinateRegion: $locationManager.region,
                showsUserLocation: true,
                annotationItems: selectedPin.map { [$0] } ?? []) { pin in
                MapMarker(coordinate: pin.coordinate, tint: .red)
            }
            .ignoresSafeArea()
            .onTapGesture { location in
                // Convert screen tap point to map coordinate
                let coordinate = locationManager.region.coordinate(from: location)
                selectedPin = IdentifiableCoordinate(coordinate: coordinate)
            }
            
            // MARK: My Location Button
            Button {
                withAnimation {
                    if let userLocation = locationManager.userLocation {
                        locationManager.region = MKCoordinateRegion(
                            center: userLocation,
                            span: /*MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)*/
                            MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    }
                }
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(12)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(20)
        }
        // ← Show alert if user denied location
                .alert("Location Access Needed", isPresented: $locationManager.permissionDenied) {
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Please allow location access in Settings so we can show your position on the map.")
                }
    }//body
}

// MARK: - Helpers

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

extension MKCoordinateRegion {
    /// Converts a SwiftUI tap CGPoint into a map coordinate
    func coordinate(from point: CGPoint) -> CLLocationCoordinate2D {
        let screenSize = UIScreen.main.bounds.size
        
        let latDelta = center.latitude  - (span.latitudeDelta  / 2) + (Double(point.y / screenSize.height) * span.latitudeDelta)
        let lonDelta = center.longitude - (span.longitudeDelta / 2) + (Double(point.x / screenSize.width)  * span.longitudeDelta)
        
        return CLLocationCoordinate2D(latitude: latDelta, longitude: lonDelta)
    }
}

// MARK: - Preview

#Preview {
    MapView()
}

