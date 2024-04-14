//
//  Room.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

class Room: Decodable, ObservableObject {
    var id: Int
    var name: String
    var building: Room.Building
    var image: Int?
    
    init(id: Int, name: String, building: Room.Building, image: Int?) {
        self.id = id
        self.name = name
        self.building = building
        self.image = image
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case building
        case image
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.building = try container.decode(Room.Building.self, forKey: .building)
        self.image = try? container.decodeIfPresent(Int.self, forKey: .image)
    }
}

extension Room: Identifiable { }
