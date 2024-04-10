//
//  CafeteriaListItem.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension Cafeteria {
    struct ListItem: Decodable {
        var id: Int
        
        func construct(with additional: AdditionalInformation) -> Cafeteria {
            .init(id: self.id,
                  meals: additional.meals)
        }
    }
}

extension Cafeteria.ListItem {
    struct AdditionalInformation: Decodable {
        var meals: [Meal]
    }
}
