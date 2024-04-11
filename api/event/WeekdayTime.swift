//
//  WeekdayTime.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

struct WeekdayTime: Comparable {
    var weekday: Int
    var time: Meeting.Time
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.weekday < rhs.weekday { return true }
        if lhs.weekday > rhs.weekday { return false }
        return lhs.time < rhs.time
    }
}

extension WeekdayTime: Hashable { }
