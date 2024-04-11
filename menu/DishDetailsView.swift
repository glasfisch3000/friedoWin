//
//  DishDetailsView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import SwiftUI

struct DishDetailsView: View {
    var dish: Dish
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text(dish.food.name + dish.food.diet.emojisString)
                    
                    if !dish.food.description.isEmpty {
                        Text(dish.food.description)
                    }
                }
            }
            
            Section("Prices") {
                LabeledContent("Student", value: dish.studentPrice.value, format: .currency(code: dish.studentPrice.currency))
                LabeledContent("Employee", value: dish.employeePrice.value, format: .currency(code: dish.employeePrice.currency))
                LabeledContent("Guest", value: dish.guestPrice.value, format: .currency(code: dish.guestPrice.currency))
            }
            
            if let ingredients = dish.ingredients, !ingredients.isEmpty {
                Section("Ingredients") {
                    ForEach(ingredients.indices.map { $0 }) { index in
                        ingredientItem(ingredients[index])
                    }
                }
            }
        }
        .navigationTitle("Dish Details")
    }
    
    @ViewBuilder private func ingredientItem(_ food: Food) -> some View {
        VStack(alignment: .leading) {
            LabeledContent(food.name, value: food.diet.emojis.joined())
            
            if !food.description.isEmpty {
                Text(food.description)
                    .font(.caption)
            }
        }
        .listRowBackground(food.diet.color.opacity(0.4))
    }
}
