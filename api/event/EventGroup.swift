//
//  EventGroup.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

extension Event {
    class Group: Decodable, ObservableObject {
        private let uuid = UUID()
        
        @Published var number: Int?
        @Published var meetings: [Meeting]
        
        init(number: Int?, meetings: [Meeting]) {
            self.number = number
            self.meetings = meetings
        }
    }
}

extension Event.Group {
    enum CodingKeys: CodingKey {
        case number
        case meetings
    }
}

extension Event.Group: Identifiable {
    var id: String { number?.description ?? uuid.uuidString }
}

extension Event.Group: Hashable {
    static func == (lhs: Event.Group, rhs: Event.Group) -> Bool {
        lhs.number == rhs.number && lhs.meetings == rhs.meetings
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(number)
        hasher.combine(meetings)
    }
}
