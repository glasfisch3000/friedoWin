//
//  MeetingView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

struct MeetingView: View {
    @APIFetchable var event: FetchableStatus<Event>
    var group: Event.Group? = nil
    var meeting: Meeting
    
    var colorHash: Double
    var simple: Bool = false
    
    @State private var presented: Meeting? = nil
    
    var body: some View {
        Form {
            if simple {
                eventSectionSimple()
            } else {
                eventSection()
            }
            
            dateTimeSection()
            
            additionalInfoSection()
            
            remarkSection()
            
            if let group = group {
                groupSections(group)
            }
        }
        .navigationTitle("Meeting Info")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $presented) { meeting in
            MeetingView(event: self._event, meeting: meeting, colorHash: self.colorHash, simple: true)
        }
    }
    
    @ViewBuilder private func eventSection() -> some View {
        Section {
            switch event {
            case .error:
                Text("Unable to load event.").foregroundStyle(.red)
                if let type = meeting.type {
                    LabeledContent("Type", value: type.description)
                }
            case .loading:
                ProgressView()
                if let type = meeting.type {
                    LabeledContent("Type", value: type.description)
                }
            case .value(let event):
                NavigationLink {
                    EventView(event: _event)
                } label: {
                    LabeledContent("Event") {
                        Text(event.name)
                            .lineLimit(1)
                    }
                }
                
                LabeledContent("Type", value: (meeting.type ?? event.type).description)
            }
        }
    }
    
    @ViewBuilder private func eventSectionSimple() -> some View {
        Section {
            switch event {
            case .error:
                if let type = meeting.type {
                    LabeledContent("Type", value: type.description)
                } else {
                    LabeledContent("Type") {
                        Text("Error").foregroundStyle(.red)
                    }
                }
            case .loading:
                if let type = meeting.type {
                    LabeledContent("Type", value: type.description)
                } else {
                    LabeledContent("Type") {
                        ProgressView()
                    }
                }
            case .value(let event):
                LabeledContent("Type", value: (meeting.type ?? event.type).description)
            }
        }
    }
    
    @ViewBuilder private func dateTimeSection() -> some View {
        Section("Date and Time") {
            let startTime = meeting.fromTime?.asDate()
            let endTime = meeting.toTime?.asDate()
            if startTime != nil || endTime != nil {
                LabeledContent("Time") {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        if let startTime = startTime {
                            Text(startTime, format: Date.FormatStyle(time: .shortened))
                        } else {
                            Text("?")
                        }
                        
                        Text(" - ")
                        
                        if let endTime = endTime {
                            Text(endTime, format: Date.FormatStyle(time: .shortened))
                        } else {
                            Text("?")
                        }
                    }
                }
            }
            
            if let offset = meeting.timeOffset {
                LabeledContent("Time Offset", value: offset.description)
            }
            
            LabeledContent("Day", value: Calendar.autoupdatingCurrent.weekdaySymbols[meeting.weekday] + ", " + meeting.frequency.description)
            
            if let startDate = meeting.fromDate.asDate(), let endDate = meeting.toDate.asDate() {
                LabeledContent("Duration") {
                    Text(startDate, format: Date.FormatStyle(date: .numeric)) +
                    Text(" - ") +
                    Text(endDate, format: Date.FormatStyle(date: .numeric))
                }
            }
        }
    }
    
    @ViewBuilder private func additionalInfoSection() -> some View {
        Section {
            LabeledContent("Online", value: meeting.online ? "Yes" : "No")
            
            if let room = meeting.room {
                NavigationLink {
                    RoomView(room: $event.room(room.id))
                } label: {
                    LabeledContent("Room") {
                        Text(room.name)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func remarkSection() -> some View {
        if let remark = meeting.remark {
            Section("Remark") {
                Text(remark)
            }
        }
    }
    
    @ViewBuilder private func groupSections(_ group: Event.Group) -> some View {
        Section {
            LabeledContent("Group") {
                HStack(spacing: 0) {
                    if let number = group.number {
                        Text(number, format: .number)
                    } else {
                        Text("?")
                    }
                    
                    Text(" of ")
                    
                    switch event.groups {
                    case .error:
                        Text("?")
                    case .loading:
                        ProgressView()
                    case .value(let groups):
                        if let groups = groups {
                            Text(groups.count, format: .number)
                        } else {
                            Text("-")
                        }
                    }
                }
            }
            
            if !simple, let groups = event.value?.groups {
                NavigationLink {
                    EventGroupsView(event: self._event, groups: groups, colorHash: colorHash)
                } label: {
                    Text("All Groups")
                        .badge(groups.count)
                        .badgeProminence(.decreased)
                }
            }
        }
        
        Section("Meetings") {
            switch event {
            case .error: meetingsView(group: group, event: nil)
            case .loading: ProgressView()
            case .value(let event): meetingsView(group: group, event: event)
            }
        }
    }
    
    @ViewBuilder private func meetingsView(group: Event.Group, event: Event?) -> some View {
        let sorted = sort(group.meetings, event: event)
        TimetableView(weekdays: sorted) { view in
            if view.entry.isSecondary {
                Button {
                    presented = view.entry.meeting
                } label: { view }
                .buttonStyle(.plain)
            } else {
                view
            }
        }
        
        ForEach(group.meetings.filter { $0.frequency == .once }.sorted {
            if let date1 = $0.fromDate.asDate(), let date2 = $1.fromDate.asDate() { return date1 < date2 }
            if let wt1 = $0.weekdayTime, let wt2 = $1.weekdayTime { return wt1 < wt2 }
            return $0.weekday < $1.weekday
        }) { meeting in
            NavigationLink {
                MeetingView(event: self._event, meeting: meeting, colorHash: colorHash, simple: true)
            } label: {
                if let date = meeting.fromDate.asDate() {
                    LabeledContent(meeting.type?.description ?? "Meeting", value: date, format: Date.FormatStyle(date: .numeric))
                } else {
                    Text(meeting.type?.description ?? "Meeting")
                }
            }
        }
    }
    
    func sort(_ meetings: [Meeting], event: Event?) -> [Int: TimetableWeekday<Item>] {
        let meetings = meetings
            .filter { $0.frequency != .once }
            .compactMap { meeting -> (Meeting, Meeting.Time, Meeting.Time)? in
                guard let fromTime = meeting.fromTime else { return nil }
                guard let toTime = meeting.toTime else { return nil }
                return (meeting, fromTime, toTime)
            }
            .sorted {
                let wt0 = WeekdayTime(weekday: $0.0.weekday, time: $0.1)
                let wt1 = WeekdayTime(weekday: $1.0.weekday, time: $1.1)
                return wt0 < wt1
            }
        
        var weekdays: [Int: TimetableWeekday<Item>] = [:]
        
        for weekday in 0..<7 {
            var columns: [TimetableColumn<Item>] = []
            
            for meetingIndex in meetings.indices {
                let (meeting, fromTime, toTime) = meetings[meetingIndex]
                
                guard meeting.weekday == weekday else { continue }
                
                let entry = Item(index: meetingIndex, colorHash: colorHash, isSecondary: meeting.id != self.meeting.id, event: event, meeting: meeting, start: fromTime, end: toTime)
                let column = columns.firstIndex {
                    !$0.contains { $0.timeIntersects(with: entry) }
                }
                
                if let column = column {
                    columns[column].append(entry)
                } else {
                    columns.append([entry])
                }
            }
            
            weekdays[weekday] = columns
        }
        
        return weekdays
    }
}

extension MeetingView {
    struct Item: TimetableEntry {
        var index: Int
        var colorHash: Double
        var isSecondary: Bool
        
        var event: Event?
        var meeting: Meeting
        
        var start: Meeting.Time
        var end: Meeting.Time
        
        var id: ID { meeting.id }
        
        var type: Event.EventType? { meeting.type ?? event?.type }
        
        var title: String { "Meeting \(index+1)" }
        var subtitle: String { type?.description ?? "" }
        
        func color(colorScheme: ColorScheme) -> Color {
            return Color(hash: colorHash, colorScheme: colorScheme)
        }
    }
}
