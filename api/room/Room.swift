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
    var image: Int
    
    init(id: Int, name: String, building: Room.Building, image: Int) {
        self.id = id
        self.name = name
        self.building = building
        self.image = image
    }
}

extension Room: Identifiable { }
