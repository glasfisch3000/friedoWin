//
//  Schedule.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 06.04.24.
//

import Foundation

typealias Schedule = [Event]

extension Schedule {
    var firstEventOfTheWeek: (Event, WeekdayTime)? {
        self.reduce(nil) { result, event in
            guard let firstOccurrence = event.firstOccurrence else { return result }
            guard let result = result else { return (event, firstOccurrence) }
            
            if firstOccurrence < result.1 { return (event, firstOccurrence) }
            if firstOccurrence > result.1 { return result }
            if event.sortableShortText < result.0.sortableShortText { return (event, firstOccurrence) }
            return result
        }
    }
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        guard let feotw0 = lhs.firstEventOfTheWeek else { return false }
        guard let feotw1 = rhs.firstEventOfTheWeek else { return true }
        
        if feotw0.1 < feotw1.1 { return true }
        if feotw0.1 > feotw1.1 { return false }
        return feotw0.0.sortableShortText < feotw1.0.sortableShortText
    }
}
