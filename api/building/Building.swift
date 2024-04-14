//
//  Building.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

class Building: Decodable, ObservableObject {
    var id: Int
    
    var name: String
    var shortName: String
    var additionalName: String
    
    var campus: String
    var academyBuilding: String
    var location: Location?
    
    init(id: Int, name: String, shortName: String, additionalName: String, campus: String, academyBuilding: String, location: Location? = nil) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.additionalName = additionalName
        self.campus = campus
        self.academyBuilding = academyBuilding
        self.location = location
    }
}

extension Building: Identifiable { }
