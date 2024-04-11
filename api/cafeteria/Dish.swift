//
//  Dish.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

class Dish: Decodable, ObservableObject {
    @Published var food: Food
    
    @Published var studentPrice: Dish.Price
    @Published var employeePrice: Dish.Price
    @Published var guestPrice: Dish.Price
    
    @Published var ingredients: [Food]?
    
    init(food: Food, studentPrice: Dish.Price, employeePrice: Dish.Price, guestPrice: Dish.Price, ingredients: [Food]?) {
        self.food = food
        self.studentPrice = studentPrice
        self.employeePrice = employeePrice
        self.guestPrice = guestPrice
        self.ingredients = ingredients
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decode(String.self, forKey: .description)
        let diet = try container.decode(String.self, forKey: .diet)
        self.food = .init(name: name, description: description, diet: diet)
        
        self.studentPrice = try container.decode(Dish.Price.self, forKey: .studentPrice)
        self.employeePrice = try container.decode(Dish.Price.self, forKey: .employeePrice)
        self.guestPrice = try container.decode(Dish.Price.self, forKey: .guestPrice)
        self.ingredients = try container.decode([Food]?.self, forKey: .ingredients)
    }
}

extension Dish {
    enum CodingKeys: CodingKey {
        case name
        case description
        case diet
        case studentPrice
        case employeePrice
        case guestPrice
        case ingredients
    }
}
