
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject private var viewModel = PlaceSearchViewModel()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.4858, longitude: 39.1925),
        latitudinalMeters: 8000,
        longitudinalMeters: 8000
    )

    @AppStorage("catLostDate") private var lostDateTimestamp: Double = Date().timeIntervalSince1970
    private var lostDate: Date { Date(timeIntervalSince1970: lostDateTimestamp) }
    private var monthsLost: Int { RadiusCalculator.monthsSince(lostDate) }

    @State private var showDateSheet   = false
    @State private var showRadiusAlert = false

    var body: some View {
        ZStack(alignment: .top) {

            // MARK: Map
            PlaceMapView(
                region: $region,
                annotations: viewModel.annotations,
                overlays: viewModel.overlays,
                onTap: { coordinate in
                    region = MKCoordinateRegion(
                        center: coordinate,
                        latitudinalMeters: viewModel.searchRadiusMeters * 3,
                        longitudinalMeters: viewModel.searchRadiusMeters * 3
                    )
                    viewModel.search(near: coordinate)
                }
            )
            .ignoresSafeArea()

            // MARK: Top UI
            VStack(spacing: 0) {
                Group {
                    if viewModel.isLoading {
                        BadgeView(text: "🔍 Searching...")
                    } else if viewModel.selectedCoordinate != nil {
                        BadgeView(text: "📍 \(viewModel.annotations.count) places · \(Int(viewModel.searchRadiusMeters))m")
                    } else {
                        BadgeView(text: "👆 Tap map to set search center")
                    }
                }
                .padding(.top, 12)

                CategoryToggleBar(viewModel: viewModel)
                    .padding(.top, 8)
            }

            // MARK: Bottom Button
            VStack {
                Spacer()
                Button { showDateSheet = true } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar.badge.clock").font(.title3)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Cat Last Seen").font(.caption2).opacity(0.8)
                            Text(monthsLost == 0 ? "Set date" : "\(monthsLost) month\(monthsLost == 1 ? "" : "s") ago")
                                .font(.caption).fontWeight(.semibold)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.orange)
                    .cornerRadius(30)
                    .shadow(radius: 6)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear { viewModel.updateRadius(for: lostDate) }
        .sheet(isPresented: $showDateSheet) {
            LostDateSheet(
                lostDate: Binding(
                    get: { lostDate },
                    set: { lostDateTimestamp = $0.timeIntervalSince1970 }
                ),
                isPresented: $showDateSheet
            ) { date in
                viewModel.updateRadius(for: date)
                showRadiusAlert = true
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .alert("🔵 Search Radius Updated", isPresented: $showRadiusAlert) {
            Button("Got it!", role: .cancel) { }
        } message: {
            Text("""
            📅 Months missing: \(monthsLost)
            📏 New radius: \(Int(viewModel.searchRadiusMeters))m
            🧮 Formula: 500 + (\(monthsLost) × 20)m

            \(viewModel.selectedCoordinate != nil ? "Tap the map to re-search with the new radius." : "Now tap the map to start searching.")
            """)
        }
    }
}

#Preview {
    ContentView()
}
