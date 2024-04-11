//
//  Diet.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import SwiftUI

struct Diet: OptionSet {
    var rawValue: Int64
}

extension Diet: Hashable { }

extension Diet: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.rawValue = try container.decode(RawValue.self)
    }
}

extension Diet {
    var emojis: [String] {
        var emojis: [String] = []

        // non-vegetarian products
        if self.contains(.fish) { emojis.append("🐟") }
        if self.contains(.pork) { emojis.append("🥓") }
        if self.contains(.beef) { emojis.append("🥩") }
        if self.contains(.poultry) { emojis.append("🍗") }
        if self.contains(.crustacean) { emojis.append("🦀") }
        if self.contains(.animalGelatin) { emojis.append("🧫") }
        if self.contains(.animalRennet) { emojis.append("🧪") }
        if self.contains(.carmine) { emojis.append("🩸") }
        if !self.contains(.vegetarian) && emojis.isEmpty { emojis.append("🍖") } // if not already mentioned: non-vegetarian

        // non-vegan products
        if self.contains(.milk) { emojis.append("🥛") }
        if self.contains(.chickenEgg) { emojis.append("🥚") }

        // non-vegan products, only mention if vegetarian
        if self.contains(.vegetarian) {
            if self.contains(.honey) { emojis.append("🍯") }
            if !self.contains(.vegan) && self.contains(.waxed) { emojis.append("🕯️") } // if not vegan and waxed, it's bee stuff
        }

        if !self.contains(.vegan) && emojis.isEmpty { emojis.append("🍳") } // if not already mentioned: non-vegan

        if self.contains(.caffeine) { emojis.append("☕️") }
        if self.contains(.alcohol) { emojis.append("🍻") }
        if !self.intersection(.gluten).isEmpty { emojis.append("🌾") }

        return emojis
    }
    
    var emojisString: String {
        var result = emojis.joined()
        if !result.isEmpty { result = " " + result }
        return result
    }
    
    var color: Color {
        if self.contains(.vegan) {
            if self.intersection(.gluten).isEmpty {
                .blue
            } else {
                .green
            }
        } else if self.contains(.vegetarian) {
            .yellow
        } else {
            .red
        }
    }
}
