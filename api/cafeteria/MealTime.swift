//
//  MealTime.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension Meal {
    enum Time: String, Decodable {
        case morning
        case noon
        case afternoon
        case evening
    }
}

extension Meal.Time: Hashable { }

extension Meal.Time: Identifiable {
    var id: Self { self }
}

extension Meal.Time: Comparable {
    var sortRank: Int {
        switch self {
        case .morning: 1
        case .noon: 2
        case .afternoon: 3
        case .evening: 4
        }
    }
    
    static func < (lhs: Meal.Time, rhs: Meal.Time) -> Bool {
        lhs.sortRank < rhs.sortRank
    }
}

extension Meal.Time: CustomStringConvertible {
    var description: String {
        switch self {
        case .morning: "Breakfast"
        case .noon: "Lunch"
        case .afternoon: "Afternoon"
        case .evening: "Dinner"
        }
    }
}
