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
    var images: [Int]?
    
    init(id: Int, name: String, building: Room.Building, images: [Int]?) {
        self.id = id
        self.name = name
        self.building = building
        self.images = images
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case building
        case images
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.building = try container.decode(Room.Building.self, forKey: .building)
        self.images = try? container.decodeIfPresent([Int].self, forKey: .images)
    }
}

extension Room: Identifiable { }

extension Room {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&moduleCall=webInfo&publishConfFile=webInfoRaum&publishSubDir=raum&raum.rgid=\(id)")
    }
}
