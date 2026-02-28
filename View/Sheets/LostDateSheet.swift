//
//  LostDateSheet.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import SwiftUI

struct LostDateSheet: View {

    @Binding var lostDate: Date
    @Binding var isPresented: Bool
    var onConfirm: (Date) -> Void

    private var monthsLost: Int  { RadiusCalculator.monthsSince(lostDate) }
    private var newRadius: Double { RadiusCalculator.calculate(from: lostDate) }

    var body: some View {
        VStack(spacing: 20) {

            // Handle bar
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            // Title
            HStack(spacing: 8) {
                Image(systemName: "cat.fill").foregroundStyle(.orange).font(.title2)
                Text("When was your cat last seen?").font(.headline)
            }

            // Date picker
            DatePicker("", selection: $lostDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding(.horizontal)

            // Live preview card
            HStack(spacing: 0) {
                statCell(value: "\(monthsLost)", label: "months\nmissing", color: .orange)
                Divider().frame(height: 50)
                statCell(value: "\(Int(newRadius))m", label: "search\nradius", color: .blue)
                Divider().frame(height: 50)
                statCell(value: "500+(\(monthsLost)×20)", label: "formula", color: .purple, isSmall: true)
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(16)
            .padding(.horizontal)

            // Confirm
            Button {
                onConfirm(lostDate)
                isPresented = false
            } label: {
                Text("Apply & Search")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orange)
                    .foregroundStyle(.white)
                    .cornerRadius(16)
                    .padding(.horizontal)
            }

            Spacer()
        }
    }

    @ViewBuilder
    private func statCell(value: String, label: String, color: Color, isSmall: Bool = false) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(isSmall ? .caption : .title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
