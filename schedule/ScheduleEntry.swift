//
//  ScheduleEntry.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

struct ScheduleEntry {
    var event: Event
    var group: Event.Group
    var meeting: Meeting
    
    var colorHash: Double
}

extension ScheduleEntry: TimetableEntry {
    var id: ID { meeting.id }
    var type: Event.EventType { meeting.type ?? event.type }
    
    var title: String { event.name }
    var subtitle: String { type.description }
    
    func color(colorScheme: ColorScheme) -> Color {
        Color(hash: colorHash, colorScheme: colorScheme)
    }
    
    var isSecondary: Bool { type.isSecondary }
    
    var start: Meeting.Time { meeting.fromTime }
    var end: Meeting.Time { meeting.toTime }
}

extension Color {
    init(hash: Double, colorScheme: ColorScheme) {
        switch colorScheme {
        case .light: self.init(oklabL: 0.6, chroma: 0.6, hash: hash)
        default: self.init(oklabL: 0.3, chroma: 0.5, hash: hash)
        }
    }
}
