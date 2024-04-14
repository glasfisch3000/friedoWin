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
