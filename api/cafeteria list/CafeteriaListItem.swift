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
        var name: String
        
        func construct(with additional: AdditionalInformation) -> Cafeteria {
            .init(id: self.id,
                  name: self.name,
                  meals: additional)
        }
    }
}

extension Cafeteria.ListItem {
    typealias AdditionalInformation = [Meal]
}
