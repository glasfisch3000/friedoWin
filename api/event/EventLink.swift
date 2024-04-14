//
//  EventLink.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 14.04.24.
//

extension Event {
    struct Link {
        var title: String
        var link: String
    }
}

extension Event.Link: Decodable { }
extension Event.Link: Hashable { }

extension Event.Link: Identifiable {
    var id: Self { self }
}
