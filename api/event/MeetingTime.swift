//
//  MeetingTime.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

extension Meeting {
    struct Time: Decodable {
        var hour: Int
        var minute: Int
        
        init(hour: Int, minute: Int) {
            self.hour = hour
            self.minute = minute
        }
    }
}

extension Meeting.Time: Hashable { }

extension Meeting.Time: Comparable {
    static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.hour < rhs.hour { return true }
        if lhs.minute < rhs.minute { return true }
        return false
    }
}

extension Meeting.Time {
    func fullHour(up: Bool = false) -> Int {
        if up && minute > 0 {
            return hour + 1
        } else {
            return hour
        }
    }
    
    var inHours: Double {
        Double(hour) + Double(minute)/60
    }
    
    var inMinutes: Int {
        hour * 60 + minute
    }
}

extension Meeting.Time {
    var normalized: Self {
        switch minute {
        case 60...: return .init(hour: hour + minute/60, minute: minute%60)
        case ..<0: return .init(hour: hour - Int(minute.magnitude+59)/60, minute: (minute%60 + 60) % 60)
        default: return self
        }
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        .init(hour: lhs.hour + rhs.hour, minute: lhs.minute + rhs.minute).normalized
    }
    
    static func - (lhs: Self, rhs: Self) -> Self {
        .init(hour: lhs.hour - rhs.hour, minute: lhs.minute - rhs.minute).normalized
    }
}

extension Meeting.Time {
    func asDate(with calendar: Calendar = .autoupdatingCurrent) -> Date? {
        calendar.date(from: self.asDateComponents)
    }
    
    var asDateComponents: DateComponents {
        .init(hour: self.hour, minute: self.minute)
    }
}
