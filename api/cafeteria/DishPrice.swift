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

extension Dish.Price: Hashable { }

extension Dish.Price {
    enum PriceType: String, Hashable {
        case student
        case employee
        case guest
    }
}

extension Dish.Price: Comparable {
    static func < (lhs: Dish.Price, rhs: Dish.Price) -> Bool {
        if lhs.currency < rhs.currency { return true }
        if lhs.currency > rhs.currency { return false }
        return lhs.value < rhs.value
    }
}
