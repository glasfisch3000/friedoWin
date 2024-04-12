//
//  MeetingRoom.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

extension Meeting {
    struct Room: Decodable {
        var id: Int
        var name: String
        var buildingName: String
    }
}


extension Meeting.Room: Identifiable { }
extension Meeting.Room: Hashable { }
