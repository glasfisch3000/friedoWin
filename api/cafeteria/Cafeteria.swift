//
//  Cafeteria.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

class Cafeteria: Decodable, ObservableObject {
    @Published var id: Int
    @Published var meals: [Meal]
    
    init(id: Int, meals: [Meal]) {
        self.id = id
        self.meals = meals
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(Published<Int>.self, forKey: .id)
        self._meals = try container.decode(Published<[Meal]>.self, forKey: .meals)
    }
}

extension Cafeteria {
    enum CodingKeys: CodingKey {
        case id
        case meals
    }
}

extension Cafeteria: Identifiable { }
