//
//  MeetingTimeOffset.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

extension Meeting {
    enum TimeOffset: Int {
        case none = 0
        case ct = 15
    }
}

extension Meeting.TimeOffset: Hashable { }
extension Meeting.TimeOffset: Decodable { }

extension Meeting.TimeOffset: CustomStringConvertible {
    var description: String {
        switch self {
        case .none: "No Offset"
        case .ct: "Cum Tempore (15min)"
        }
    }
}
