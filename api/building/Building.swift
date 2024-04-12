//
//  Building.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

class Building: Decodable, ObservableObject {
    var id: Int
    var campus: String
    var academyBuilding: String
    var location: Location
    
    init(id: Int, campus: String, academyBuilding: String, location: Location) {
        self.id = id
        self.campus = campus
        self.academyBuilding = academyBuilding
        self.location = location
    }
}

extension Building: Identifiable { }
