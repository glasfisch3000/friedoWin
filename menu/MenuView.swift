//
//  MenuView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import SwiftUI

struct MenuView: View {
    @ServersFetchable var menu: FetchableStatus<FoodMenu>
    
    @AppStorage("mensa.timeSelection") private var selection: Meal.Time = .noon
    @AppStorage("mensa.priceSelection") private var priceSelection: Dish.Price.PriceType = .student
    
    @State private var detailsPresented: Dish? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                switch menu {
                case .error:
                    errorView()
                case .loading:
                    loadingView()
                case .value(let menu):
                    valueView(menu)
                }
            }
            .refreshable {
                await _menu.loadValue()
            }
            .navigationTitle("Cafeteria")
            .sheet(item: $detailsPresented) { dish in
                NavigationStack {
                    DishDetailsView(dish: dish)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    detailsPresented = nil
                                }
                                .keyboardShortcut(.cancelAction)
                                .keyboardShortcut(.defaultAction)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ScrollView {
            ProgressView()
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        ScrollView {
            VStack {
                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                    .font(.title)
                
                Text("Unable to load menu.")
            }
        }
    }
    
    @ViewBuilder private func valueView(_ menu: FoodMenu) -> some View {
        if menu.isEmpty {
            ScrollView {
                Text("No menu available.")
            }
        } else {
            Picker(selection: $selection) {
                ForEach(menu.keys.sorted()) { time in
                    Text(time.description)
                }
            } label: { }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            
            List {
                Picker("Show Price", selection: $priceSelection) {
                    Text("Student").tag(Dish.Price.PriceType.student)
                    Text("Employee").tag(Dish.Price.PriceType.employee)
                    Text("Guest").tag(Dish.Price.PriceType.guest)
                }
                
                timeView(selection, entries: menu[selection] ?? [:])
                    .listRowSeparatorTint(.secondary.opacity(0.5))
            }
        }
    }
    
    @ViewBuilder private func timeView(_ time: Meal.Time, entries: Cafeteria.Menu) -> some View {
        ForEach(entries.sorted { $0.key.id < $1.key.id }, id: \.key) { (cafeteria, dishes) in
            Section(cafeteria.name) {
                ForEach(dishes.sorted(with: priceSelection)) { dish in
                    dishView(dish)
                        .listRowBackground(dish.food.diet.color.opacity(0.4))
                }
            }
        }
    }
    
    @ViewBuilder private func dishView(_ dish: Dish) -> some View {
        Button {
            detailsPresented = dish
        } label: {
            VStack(alignment: .leading) {
                LabeledContent(dish.food.name + dish.food.diet.emojisString) {
                    let price = dish.price(type: priceSelection)
                    Text(price.value, format: .currency(code: price.currency))
                }
                
                if !dish.food.description.isEmpty {
                    Text(dish.food.description)
                        .font(.caption)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
