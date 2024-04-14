//
//  Room.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

class Room: Decodable, ObservableObject {
    var id: Int
    var type: RoomType
    
    var name: String
    var shortName: String
    var additionalName: String
    
    var building: Room.Building
    var images: [Int]?
    
    init(id: Int, type: RoomType, name: String, shortName: String, additionalName: String, building: Room.Building, images: [Int]? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.shortName = shortName
        self.additionalName = additionalName
        self.building = building
        self.images = images
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decode(RoomType.self, forKey: .type)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.shortName = try container.decode(String.self, forKey: .shortName)
        self.additionalName = try container.decode(String.self, forKey: .additionalName)
        
        self.building = try container.decode(Room.Building.self, forKey: .building)
        self.images = try container.decodeIfPresent([Int].self, forKey: .images)
    }
}

extension Room {
    enum CodingKeys: CodingKey {
        case id
        case type
        case name
        case shortName
        case additionalName
        case building
        case images
    }
}

extension Room: Identifiable { }

extension Room {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&moduleCall=webInfo&publishConfFile=webInfoRaum&publishSubDir=raum&raum.rgid=\(id)")
    }
}
