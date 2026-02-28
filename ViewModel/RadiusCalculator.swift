//
//  RadiusCalculator.swift
//  MeowMap
//
//  Created by Reem Alghamdi on 11/09/1447 AH.
//

import Foundation

struct RadiusCalculator {
    static let baseRadius: Double    = 500
    static let radiusPerMonth: Double = 20

    static func calculate(from lostDate: Date) -> Double {
        Double(monthsSince(lostDate)) * radiusPerMonth + baseRadius
    }

    static func monthsSince(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: date, to: .now)
        return max(0, components.month ?? 0)
    }
}
