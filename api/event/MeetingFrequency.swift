//
//  MeetingFrequency.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

extension Meeting {
    enum Frequency: String, Decodable {
        case once
        case weekly
        case fortnightly
    }
}

extension Meeting.Frequency: CustomStringConvertible {
    var description: String {
        switch self {
        case .once: "Once"
        case .weekly: "Weekly"
        case .fortnightly: "Biweekly"
        }
    }
}

extension Meeting.Frequency: Hashable { }
