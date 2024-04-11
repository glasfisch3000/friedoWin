//
//  Food.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

struct Food {
    var name: String
    var description: String
    var diet: Diet
}

extension Food: Hashable { }

extension Food: Decodable {
    enum CodingKeys: CodingKey {
        case name
        case description
        case diet
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = Self.formatName(try container.decode(String.self, forKey: .name))
        self.description = Self.formatDescription(try container.decode(String.self, forKey: .description))
        self.diet = try container.decode(Diet.self, forKey: .diet)
    }
    
    static func formatName(_ string: String) -> String {
        var result = ""
        
        var first = true
        for character in string.trimmingCharacters(in: .whitespacesAndNewlines) {
            if first {
                first = false
                result += character.uppercased()
            } else {
                result += [character]
            }
        }
        
        return result
    }
    
    static func formatDescription(_ string: String) -> String {
        string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
