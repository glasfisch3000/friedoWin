//
//  DishPrice.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension Dish {
    struct Price: Decodable {
        var value: Double
        var currency: String
    }
}
