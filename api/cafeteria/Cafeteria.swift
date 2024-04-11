//
//  Cafeteria.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

class Cafeteria: Decodable, ObservableObject {
    @Published var id: Int
    @Published var name: String
    @Published var meals: [Meal]
    
    init(id: Int, name: String, meals: [Meal]) {
        self.id = id
        self.name = name
        self.meals = meals
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.meals = try container.decode([Meal].self, forKey: .meals)
    }
}

extension Cafeteria {
    enum CodingKeys: CodingKey {
        case id
        case name
        case meals
    }
}

extension Cafeteria: Identifiable { }

extension Cafeteria: Hashable {
    static func == (lhs: Cafeteria, rhs: Cafeteria) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
