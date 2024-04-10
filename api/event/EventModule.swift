//
//  EventModule.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension Event {
    struct Module: Decodable {
        var id: Int
        var name: String
        var shortText: String
        var examNumber: Int
    }
}

extension Event.Module: Identifiable { }
extension Event.Module: Hashable { }
