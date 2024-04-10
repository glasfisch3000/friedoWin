//
//  ScheduleView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 06.04.24.
//

import SwiftUI
import CryptoKit
import Crypto

struct ScheduleView: View {
    @APIFetchable var schedule: FetchableStatus<Schedule>
    
    @State private var presented: ScheduleEntry? = nil
    @State private var pixelHeightPerHour: CGFloat = 60
    
    var body: some View {
        NavigationStack {
            ScrollView {
                switch schedule {
                case .error:
                    errorView()
                case .loading:
                    loadingView()
                case .value(let value):
                    valueView(value: value)
                }
            }
            .background()
            .refreshable {
                await _schedule.loadValue()
            }
            .navigationTitle("Timetable")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ProgressView()
    }
    
    @ViewBuilder private func valueView(value: Schedule) -> some View {
        let calendar = Calendar.autoupdatingCurrent
        let now = Date.now
        let year = calendar.component(.yearForWeekOfYear, from: now)
        let week = calendar.component(.weekOfYear, from: now)
        
        let sorted = sort(value, for: week, in: year, with: calendar)
        
        TimetableView(weekdays: sorted) { view in
            Button {
                presented = view.entry
            } label: {
                view
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 2)
        .sheet(item: $presented) { presented in
            NavigationStack {
                MeetingView(event: $schedule.event(presented.event.id), group: presented.group, meeting: presented.meeting, colorHash: presented.colorHash)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                self.presented = nil
                            }
                            .keyboardShortcut(.cancelAction)
                            .keyboardShortcut(.defaultAction)
                        }
                    }
            }
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        VStack {
            Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                .font(.title)
            
            Text("Unable to load schedule.")
        }
    }
    
    func sort(_ schedule: Schedule, for week: Int, in year: Int, with calendar: Calendar = .autoupdatingCurrent) -> [Int: TimetableWeekday<ScheduleEntry>] {
        var weekdays: [Int: TimetableWeekday<ScheduleEntry>] = [:]
        
        let groupedSchedule = schedule.grouped(by: \.sortableShortText).map { $0.1 }.sorted(by: <)
        
        for weekday in 0..<7 {
            var columns: [TimetableColumn<ScheduleEntry>] = []
            
            guard let weekdayDate = calendar.date(from: .init(weekday: weekday+1, weekOfYear: week, yearForWeekOfYear: year)) else { continue }
            
            let day = calendar.component(.day, from: weekdayDate)
            let month = calendar.component(.month, from: weekdayDate)
            let year = calendar.component(.year, from: weekdayDate)
            let meetingDate = Meeting.Date(day: day+1, month: month, year: year)
            
            for eventIndex in groupedSchedule.indices {
                let events = groupedSchedule[eventIndex]
                let eventColorHash = (Double(eventIndex)/Double(groupedSchedule.count) + 0.4).truncatingRemainder(dividingBy: 1)
                
                for event in events {
                    for group in event.groups {
                        for meeting in group.meetings {
                            guard meeting.isOn(meetingDate, with: calendar) ?? false else { continue }
                            
                            let entry = ScheduleEntry(event: event, group: group, meeting: meeting, colorHash: eventColorHash)
                            if let column = columns.firstIndex(where: { !$0.contains { $0.meeting.timeIntersects(with: meeting) } }) {
                                columns[column].append(entry)
                            } else {
                                columns.append([entry])
                            }
                        }
                    }
                }
            }
            
            weekdays[weekday] = columns
        }
        
        return weekdays
    }
}
