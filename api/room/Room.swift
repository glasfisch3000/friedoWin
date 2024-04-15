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
}

extension Room: Identifiable { }

extension Room {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&moduleCall=webInfo&publishConfFile=webInfoRaum&publishSubDir=raum&raum.rgid=\(id)")
    }
}
