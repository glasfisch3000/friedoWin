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
