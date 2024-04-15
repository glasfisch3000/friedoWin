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
    
    var rooms: [Building.Room]?
}

extension Building: Identifiable { }
