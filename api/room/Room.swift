//
//  Room.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

class Room: Decodable, ObservableObject {
    @Published var id: Int
    @Published var type: RoomType
    
    @Published var name: String
    @Published var shortName: String
    @Published var additionalName: String
    
    @Published var building: Room.Building
    @Published var images: [Int]?
}

extension Room: Identifiable { }

extension Room {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&moduleCall=webInfo&publishConfFile=webInfoRaum&publishSubDir=raum&raum.rgid=\(id)")
    }
}
