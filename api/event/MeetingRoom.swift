//
//  MeetingRoom.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

extension Meeting {
    class Room: Decodable {
        @Published var id: Int
        @Published var name: String
        @Published var buildingName: String
        
        init(id: Int, name: String, buildingName: String) {
            self.id = id
            self.name = name
            self.buildingName = buildingName
        }
    }
}


extension Meeting.Room: Identifiable { }

extension Meeting.Room: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.name)
        hasher.combine(self.buildingName)
    }
    
    static func == (lhs: Meeting.Room, rhs: Meeting.Room) -> Bool {
        guard lhs.id == rhs.id else { return false }
        guard lhs.name == rhs.name else { return false }
        guard lhs.buildingName == rhs.buildingName else { return false }
        return true
    }
}
