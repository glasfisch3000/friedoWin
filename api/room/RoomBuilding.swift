//
//  RoomBuilding.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

extension Room {
    struct Building: Decodable {
        var id: Int
        var name: String
    }
}

extension Room.Building: Identifiable { }
