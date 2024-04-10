//
//  TimetableEntry.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

typealias TimetableWeekday<Entry: TimetableEntry> = [TimetableColumn<Entry>]
typealias TimetableColumn<Entry: TimetableEntry> = [Entry]

protocol TimetableEntry: Identifiable {
    var title: String { get }
    var subtitle: String { get }
    
    func color(colorScheme: ColorScheme) -> Color
    var isSecondary: Bool { get }
    
    var start: Meeting.Time { get }
    var end: Meeting.Time { get }
}
