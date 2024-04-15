//
//  EventGroupsView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 09.04.24.
//

import SwiftUI

struct EventGroupsView: View {
    struct Presented: Hashable {
        var group: Event.Group
        var meeting: Meeting
        var colorHash: Double
    }
    
    enum Selection: Hashable {
        case allGroups
        case single(group: Event.Group)
    }
    
    @APIFetchable var event: FetchableStatus<Event>
    var groups: [Event.Group]
    var colorHash: Double
    
    @State private var presented: Presented? = nil
    @State private var selection: Selection = .allGroups
    
    var body: some View {
        Form {
            Picker("Show", selection: $selection) {
                Text("All Groups").tag(Selection.allGroups)
                
                ForEach(groups) { group in
                    Group {
                        if let number = group.number {
                            Text("Group ") + Text(number, format: .number)
                        } else {
                            Text("Unknown Group")
                        }
                    }
                    .tag(Selection.single(group: group))
                }
            }
            
            groupsView()
        }
        .navigationDestination(item: $presented) { presented in
            MeetingView(event: self._event, group: presented.group, meeting: presented.meeting, colorHash: presented.colorHash, simple: true)
        }
        .refreshable {
            await _event.loadValue()
        }
        .navigationTitle("Event Groups Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func groupsView() -> some View {
        switch event {
        case .error:
            Section {
                Text("Unable to load event.").foregroundStyle(.red)
            }
            
            Section {
                meetingsView(event: nil)
            }
        case .loading:
            Section {
                ProgressView()
            }
        case .value(let event):
            Section {
                meetingsView(event: event)
            }
        }
    }
    
    private var selectedGroups: [Event.Group] {
        switch selection {
        case .allGroups: self.groups
        case .single(let group): [group]
        }
    }
    
    @ViewBuilder private func meetingsView(event: Event?) -> some View {
        let groups = selectedGroups
        
        let sorted = sort(groups, event: event)
        TimetableView(weekdays: sorted) { view in
            Button {
                presented = .init(group: view.entry.group, meeting: view.entry.meeting, colorHash: view.entry.colorHash)
            } label: { view }
            .buttonStyle(.plain)
        }
        
        ForEach(groups) { group in
            ForEach(group.meetings.filter { $0.frequency == .once }.sorted {
                if let date1 = $0.fromDate.asDate(), let date2 = $1.fromDate.asDate() { return date1 < date2 }
                if let wt1 = $0.weekdayTime, let wt2 = $1.weekdayTime { return wt1 < wt2 }
                return $0.weekday < $1.weekday
            }) { meeting in
                NavigationLink {
                    MeetingView(event: self._event, group: group, meeting: meeting, colorHash: colorHash, simple: true)
                } label: {
                    if let date = meeting.fromDate.asDate() {
                        LabeledContent(meeting.type?.description ?? "Meeting", value: date, format: Date.FormatStyle(date: .numeric))
                    } else {
                        Text(meeting.type?.description ?? "Meeting")
                    }
                }
            }
        }
    }
    
    func sort(_ groups: [Event.Group], event: Event?) -> [Int: TimetableWeekday<Item>] {
        var weekdays: [Int: TimetableWeekday<Item>] = [:]
        
        let groups = groups.sorted { $0.id < $1.id }
        
        for weekday in 0..<7 {
            var columns: [TimetableColumn<Item>] = []
            
            for groupIndex in groups.indices {
                let group = groups[groupIndex]
                let groupColorHash = (Double(groupIndex)/Double(groups.count+1) + 0.4).truncatingRemainder(dividingBy: 1)
                
                for meeting in group.meetings {
                    guard meeting.frequency != .once else { continue }
                    guard meeting.weekday == weekday else { continue }
                    
                    guard let start = meeting.fromTime else { continue }
                    guard let end = meeting.toTime else { continue }
                    
                    let item = Item(event: event, group: group, meeting: meeting, start: start, end: end, colorHash: groupColorHash)
                    let column = columns.firstIndex {
                        !$0.contains { $0.timeIntersects(with: item) }
                    }
                    
                    if let column = column {
                        columns[column].append(item)
                    } else {
                        columns.append([item])
                    }
                }
            }
            
            weekdays[weekday] = columns
        }
        
        return weekdays
    }
}

extension EventGroupsView {
    struct Item: TimetableEntry {
        var event: Event?
        var group: Event.Group
        var meeting: Meeting
        
        var start: Meeting.Time
        var end: Meeting.Time
        
        var colorHash: Double
        
        var id: ID { meeting.id }
        
        var type: Event.EventType? { meeting.type ?? event?.type }
        
        var title: String {
            if let number = group.number {
                "Group \(number)"
            } else {
                "Unknown Group"
            }
        }
        
        var subtitle: String { type?.description ?? "" }
        
        func color(colorScheme: ColorScheme) -> Color {
            return Color(hash: colorHash, colorScheme: colorScheme)
        }
        
        var isSecondary: Bool { type?.isSecondary ?? false }
    }
}
