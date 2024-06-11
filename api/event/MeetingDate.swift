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

extension Meeting.Date: Comparable {
    static func < (lhs: Meeting.Date, rhs: Meeting.Date) -> Bool {
        if lhs.year < rhs.year { return true }
        if lhs.year > rhs.year { return false }
        
        if lhs.month < rhs.month { return true }
        if lhs.month > rhs.month { return false }
        
        return lhs.day < rhs.day
    }
}
