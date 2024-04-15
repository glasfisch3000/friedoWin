//
//  menu-fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension FriedoWin.Servers {
    var menu: ServersFetchable<FoodMenu> {
        ServersFetchable(source: self) { servers in
            let list = try await servers.fetchCafeteriaList()
            var menu: FoodMenu = [:]
            
            for item in list {
                let additional = try await servers.fetchCafeteria(item.id)
                let cafeteria = item.construct(with: additional)
                
                for meal in cafeteria.meals {
                    if let time = meal.time {
                        var entry = menu[time] ?? [:]
                        entry[cafeteria] = meal.dishes
                        menu[time] = entry
                    } else {
                        for time in [Meal.Time.noon, .afternoon, .evening] {
                            var entry = menu[time] ?? [:]
                            entry[cafeteria] = meal.dishes
                            menu[time] = entry
                        }
                    }
                }
            }
            
            return menu
        }
    }
}
