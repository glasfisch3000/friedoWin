//
//  TimetableView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

struct TimetableView<Item, ItemContent>: View where Item: TimetableEntry, ItemContent: View {
    typealias ItemView = TimetableItemView<Item>
    typealias Weekday = TimetableWeekday<Item>
    typealias Column = TimetableColumn<Item>
    
    var weekdays: [Int: Weekday]
    var pixelsHeightPerHour: CGFloat
    
    @ViewBuilder var item: (ItemView) -> ItemContent
    
    init(weekdays: [Int : Weekday], pixelsHeightPerHour: CGFloat = 60, @ViewBuilder item: @escaping (ItemView) -> ItemContent) {
        self.weekdays = weekdays
        self.pixelsHeightPerHour = pixelsHeightPerHour
        self.item = item
        
        var start: Int? = nil
        var end: Int? = nil
        
        for entry in weekdays.flatMap(\.value).flatMap({ $0 }) {
            if let old = start {
                start = min(old, entry.start.fullHour())
            } else { start = entry.start.fullHour() }
            
            if let old = end {
                end = max(old, entry.end.fullHour())
            } else { end = entry.end.fullHour() }
        }
        
        self.startHour = start ?? 0
        self.endHour = end ?? 24
        
        var startWeekday: Int? = nil
        var endWeekday: Int? = nil
        
        let firstDayOfTheWeek = Calendar.autoupdatingCurrent.firstWeekday-1
        for weekday in firstDayOfTheWeek ..< firstDayOfTheWeek+7 {
            guard let entry = weekdays[weekday%7], !entry.isEmpty else { continue }
            
            if startWeekday == nil { startWeekday = weekday }
            
            if let end = endWeekday { endWeekday = max(end, weekday) }
            else { endWeekday = weekday }
        }
        
        self.startWeekday = startWeekday ?? firstDayOfTheWeek
        self.endWeekday = endWeekday ?? firstDayOfTheWeek+6
    }
    
    private var startHour: Int
    private var endHour: Int
    
    private var startWeekday: Int
    private var endWeekday: Int
    
    var body: some View {
        HStack(spacing: 2) {
            timesView()
            
            ForEach((startWeekday ... endWeekday).map { $0 }) { weekday in
                weekdayView(weekday % 7, weekday: self.weekdays[weekday] ?? [])
            }
        }
    }
    
    @ViewBuilder private func timesView() -> some View {
        VStack {
            Text("T")
                .hidden()
            
            ZStack(alignment: .topTrailing) {
                ForEach((startHour ... endHour).map { $0 }) { hour in
                    Group {
                        if let date = Meeting.Time(hour: hour, minute: 0).asDate() {
                            Text(date, format: Date.FormatStyle(time: .shortened))
                        } else {
                            Text("\(hour):00")
                        }
                    }
                    .font(.caption2)
                    .offset(y: CGFloat(hour-startHour) * pixelsHeightPerHour)
                }
            }
            .frame(height: 0)
            .frame(height: CGFloat(endHour-startHour) * pixelsHeightPerHour, alignment: .topLeading)
        }
    }
    
    @ViewBuilder private func weekdayView(_ index: Int, weekday: Weekday, with calendar: Calendar = .autoupdatingCurrent) -> some View {
        VStack {
            let isToday = calendar.component(.weekday, from: .now)-1 == index
            
            Text(calendar.shortWeekdaySymbols[index])
                .foregroundStyle(isToday ? AnyShapeStyle(Color.accentColor) : AnyShapeStyle(.primary))
                .font(isToday ? .body.bold() : .body)
            
            Rectangle()
                .hidden()
                .overlay {
                    HStack(spacing: 1) {
                        ForEach(weekday.indices.map { $0 }) { column in
                            columnView(weekday[column], start: startHour)
                                .frame(height: CGFloat(endHour - startHour)*pixelsHeightPerHour, alignment: .topLeading)
                        }
                    }
                }
                .frame(height: CGFloat(endHour - startHour) * pixelsHeightPerHour)
        }
    }
    
    @ViewBuilder private func columnView(_ column: Column, start: Int) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(column) { entry in
                self.item(TimetableItemView(entry: entry))
                    .offset(y: (entry.start.inHours - Double(start)) * pixelsHeightPerHour)
                    .frame(height: (entry.end - entry.start).inHours * pixelsHeightPerHour, alignment: .topLeading)
            }
        }
    }
}

extension Int: Identifiable {
    public var id: Self { self }
}
