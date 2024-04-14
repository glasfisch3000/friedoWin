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
        
        let name = Food.formatName(try container.decode(String.self, forKey: .name))
        let description = Food.formatDescription(try container.decode(String.self, forKey: .description))
        let diet = try container.decode(Diet.self, forKey: .diet)
        self.food = .init(name: name, description: description, diet: diet)
        
        self.studentPrice = try container.decode(Dish.Price.self, forKey: .studentPrice)
        self.employeePrice = try container.decode(Dish.Price.self, forKey: .employeePrice)
        self.guestPrice = try container.decode(Dish.Price.self, forKey: .guestPrice)
        self.ingredients = try container.decodeIfPresent([Food].self, forKey: .ingredients)
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

extension Dish: Hashable {
    static func == (lhs: Dish, rhs: Dish) -> Bool {
        lhs.food == rhs.food &&
        lhs.studentPrice == rhs.studentPrice &&
        lhs.employeePrice == rhs.employeePrice &&
        lhs.guestPrice == rhs.guestPrice &&
        lhs.ingredients == rhs.ingredients
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(food)
        hasher.combine(studentPrice)
        hasher.combine(employeePrice)
        hasher.combine(guestPrice)
        hasher.combine(ingredients)
    }
}

extension Dish: Identifiable {
    var id: Dish { self }
}

extension Dish {
    func price(type: Price.PriceType) -> Price {
        switch type {
        case .student: self.studentPrice
        case .employee: self.employeePrice
        case .guest: self.guestPrice
        }
    }
}

extension Collection where Element == Dish {
    func sorted(with priceType: Dish.Price.PriceType) -> [Dish] {
        switch priceType {
        case .student: self.sorted { $0.studentPrice < $1.studentPrice }
        case .employee: self.sorted { $0.employeePrice < $1.employeePrice }
        case .guest: self.sorted { $0.guestPrice < $1.guestPrice }
        }
    }
}
