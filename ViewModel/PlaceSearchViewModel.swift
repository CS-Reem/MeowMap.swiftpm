//
//  PlaceSearchViewModel.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import MapKit
import CoreLocation

@MainActor
class PlaceSearchViewModel: ObservableObject {

    @Published var annotations: [PlaceAnnotation]      = []
    @Published var overlays: [MKOverlay]               = []
    @Published var selectedCoordinate: CLLocationCoordinate2D? = nil
    @Published var isLoading: Bool                     = false
    @Published var searchRadiusMeters: Double          = RadiusCalculator.baseRadius
    @Published var activeCategories: Set<PlaceCategory> = Set(PlaceCategory.allCases)

    // MARK: - Public API

    func updateRadius(for lostDate: Date) {
        searchRadiusMeters = RadiusCalculator.calculate(from: lostDate)
        guard let coordinate = selectedCoordinate else { return }
        search(near: coordinate)
    }

    func toggleCategory(_ category: PlaceCategory) {
        if activeCategories.contains(category) {
            activeCategories.remove(category)
        } else {
            activeCategories.insert(category)
        }
        guard let coordinate = selectedCoordinate else { return }
        search(near: coordinate)
    }

    func search(near coordinate: CLLocationCoordinate2D) {
        guard !activeCategories.isEmpty else {
            annotations = []
            overlays    = []
            return
        }

        selectedCoordinate = coordinate
        isLoading          = true
        annotations        = []
        overlays           = [MKCircle(center: coordinate, radius: searchRadiusMeters)]

        let location   = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let radius     = searchRadiusMeters
        let categories = Array(activeCategories)

        Task {
            var results: [PlaceAnnotation] = []

            await withTaskGroup(of: [PlaceAnnotation].self) { group in
                for category in categories {
                    group.addTask {
                        await Self.fetchPlaces(
                            category: category,
                            center: coordinate,
                            radius: radius,
                            userLocation: location
                        )
                    }
                }
                for await batch in group {
                    results.append(contentsOf: batch)
                }
            }

            self.annotations = results
            self.isLoading   = false
            print("✅ Found \(results.count) total places")
        }
    }

    // MARK: - Private

    private static func fetchPlaces(
        category: PlaceCategory,
        center: CLLocationCoordinate2D,
        radius: Double,
        userLocation: CLLocation
    ) async -> [PlaceAnnotation] {

        let request = MKLocalSearch.Request()
        request.region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: radius * 2,
            longitudinalMeters: radius * 2
        )
        request.resultTypes = .pointOfInterest

        if let filter = category.filter {
            request.pointOfInterestFilter = filter
        } else if let query = category.naturalQuery {
            request.naturalLanguageQuery = query
        }

        do {
            let response = try await MKLocalSearch(request: request).start()
            return response.mapItems
                .filter {
                    let loc = CLLocation(
                        latitude: $0.placemark.coordinate.latitude,
                        longitude: $0.placemark.coordinate.longitude
                    )
                    return userLocation.distance(from: loc) <= radius
                }
                .map { PlaceAnnotation(mapItem: $0, category: category) }
        } catch {
            print("❌ \(category.rawValue): \(error.localizedDescription)")
            return []
        }
    }
}
