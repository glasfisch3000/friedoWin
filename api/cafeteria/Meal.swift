//
//  Meal.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

class Meal: Decodable, ObservableObject {
    @Published var time: Meal.Time?
    @Published var dishes: [Dish]
}

extension Meal {
    enum CodingKeys: CodingKey {
        case time
        case dishes
    }
}
