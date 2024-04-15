//
//  Building.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

class Building: Decodable, ObservableObject {
    @Published var id: Int
    
    @Published var name: String
    @Published var shortName: String
    @Published var additionalName: String
    
    @Published var campus: String?
    @Published var academyBuilding: String?
    @Published var location: Location?
    
    @Published var rooms: [Building.Room]?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case shortName
        case additionalName
        case campus
        case academyBuilding
        case location
        case rooms
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.shortName = try container.decode(String.self, forKey: .shortName)
        self.additionalName = try container.decode(String.self, forKey: .additionalName)
        
        self.campus = try container.decodeIfPresent(String.self, forKey: .campus)
        self.academyBuilding = try container.decodeIfPresent(String.self, forKey: .academyBuilding)
        self.location = try container.decodeIfPresent(Building.Location.self, forKey: .location)
        
        self.rooms = try container.decodeIfPresent([Building.Room].self, forKey: .rooms)
    }
}

extension Building: Identifiable { }
