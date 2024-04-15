//
//  BuildingRoom.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 15.04.24.
//

extension Building {
    struct Room {
        var id: Int
        var name: String
        var shortName: String
        var additionalName: String
    }
}

extension Building.Room: Decodable { }
extension Building.Room: Identifiable { }
