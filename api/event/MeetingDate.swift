//
//  MeetingDate.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

extension Meeting {
    struct Date: Decodable {
        var day: Int
        var month: Int
        var year: Int
    }
}

extension Meeting.Date {
    func asDate(with calendar: Calendar = .autoupdatingCurrent) -> Date? {
        calendar.date(from: self.asDateComponents)
    }
    
    var asDateComponents: DateComponents {
        .init(year: self.year, month: self.month, day: self.day-1)
    }
}

extension Meeting.Date: Hashable { }
