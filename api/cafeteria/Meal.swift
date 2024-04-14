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
    
    init(time: Meal.Time? = nil, dishes: [Dish]) {
        self.time = time
        self.dishes = dishes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.time = try container.decodeIfPresent(Meal.Time.self, forKey: .time)
        self.dishes = try container.decode([Dish].self, forKey: .dishes)
    }
}

extension Meal {
    enum CodingKeys: CodingKey {
        case time
        case dishes
    }
}
