////
////  mm.swift
////  MeowMap
////
////  Created by Reem Alghamdi on 09/09/1447 AH.
////
//// MARK: - Content View
//import SwiftUI
//import MapKit
//import CoreLocation
//
//struct ContentView: View {
//    
//    @StateObject private var locationManager = LocationManager()
//    @State private var selectedPin: IdentifiableCoordinate?
//    
//    var body: some View {
//        ZStack(alignment: .bottomTrailing) {
//            
//            // MARK: Map
//            Map(coordinateRegion: $locationManager.region,
//                showsUserLocation: true,
//                annotationItems: selectedPin.map { [$0] } ?? []) { pin in
//                MapMarker(coordinate: pin.coordinate, tint: .red)
//            }
//            .ignoresSafeArea()
//            .onTapGesture { location in
//                // Convert screen tap point to map coordinate
//                let coordinate = locationManager.region.coordinate(from: location)
//                selectedPin = IdentifiableCoordinate(coordinate: coordinate)
//            }
//            
//            // MARK: My Location Button
//            Button {
//                withAnimation {
//                    if let userLocation = locationManager.userLocation {
//                        locationManager.region = MKCoordinateRegion(
//                            center: userLocation,
//                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                        )
//                    }
//                }
//            } label: {
//                Image(systemName: "location.fill")
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundColor(.blue)
//                    .padding(12)
//                    .background(.white)
//                    .clipShape(Circle())
//                    .shadow(radius: 4)
//            }
//            .padding(20)
//        }
//    }
//}
//
//// MARK: - Helpers
//
//struct IdentifiableCoordinate: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}
//
//extension MKCoordinateRegion {
//    /// Converts a SwiftUI tap CGPoint into a map coordinate
//    func coordinate(from point: CGPoint) -> CLLocationCoordinate2D {
//        let screenSize = UIScreen.main.bounds.size
//        
//        let latDelta = center.latitude  - (span.latitudeDelta  / 2) + (Double(point.y / screenSize.height) * span.latitudeDelta)
//        let lonDelta = center.longitude - (span.longitudeDelta / 2) + (Double(point.x / screenSize.width)  * span.longitudeDelta)
//        
//        return CLLocationCoordinate2D(latitude: latDelta, longitude: lonDelta)
//    }
//}
//
//// MARK: - Preview
//
//#Preview {
//    ContentView()
//}
//
