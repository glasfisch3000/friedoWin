//
//  MeetingTimeOffset.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.04.24.
//

import Foundation

extension Meeting {
    enum TimeOffset: Int {
        case none = 0
        case ct = 15
    }
}

extension Meeting.TimeOffset: Hashable { }
extension Meeting.TimeOffset: Decodable { }
