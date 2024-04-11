//
//  Meeting.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

class Meeting: Decodable, ObservableObject {
    @Published var type: Event.EventType? = nil
    @Published var room: Room
    @Published var online: Bool
    
    @Published var fromTime: Time?
    @Published var timeOffset: TimeOffset?
    @Published var toTime: Time?
    
    @Published var frequency: Frequency
    @Published var weekday: Int
    @Published var fromDate: Meeting.Date
    @Published var toDate: Meeting.Date
    
    @Published var remark: AttributedString?
    
    init(type: Event.EventType? = nil, room: Room, online: Bool, fromTime: Time, timeOffset: TimeOffset? = nil, toTime: Time, frequency: Frequency, weekday: Int, fromDate: Meeting.Date, toDate: Meeting.Date, remark: AttributedString? = nil) {
        self.type = type
        self.room = room
        self.online = online
        self.fromTime = fromTime
        self.timeOffset = timeOffset
        self.toTime = toTime
        self.frequency = frequency
        self.weekday = weekday
        self.fromDate = fromDate
        self.toDate = toDate
        self.remark = remark
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try? container.decode(Event.EventType.self, forKey: .type)
        self.room = try container.decode(Meeting.Room.self, forKey: .room)
        self.online = try container.decode(Bool.self, forKey: .online)
        
        self.fromTime = try container.decode(Meeting.Time.self, forKey: .fromTime)
        self.timeOffset = try container.decode(Meeting.TimeOffset?.self, forKey: .timeOffset)
        self.toTime = try container.decode(Meeting.Time.self, forKey: .toTime)
        
        self.frequency = try container.decode(Frequency.self, forKey: .frequency)
        self.weekday = try container.decode(Int.self, forKey: .weekday)
        self.fromDate = try container.decode(Meeting.Date.self, forKey: .fromDate)
        self.toDate = try container.decode(Meeting.Date.self, forKey: .toDate)
        
        self.remark = try container.decode(String?.self, forKey: .remark)?.parseFriedoLinHTML()
    }
}

extension Meeting {
    enum CodingKeys: CodingKey {
        case type
        case remark
        case room
        case online
        
        case fromTime
        case timeOffset
        case toTime
        
        case frequency
        case weekday
        case fromDate
        case toDate
    }
}

extension Meeting {
    func isOn(_ date: Meeting.Date, with calendar: Calendar = .autoupdatingCurrent) -> Bool? {
        guard let fromDate = self.fromDate.asDate(with: calendar) else { return nil }
        guard let toDate = self.toDate.asDate(with: calendar) else { return nil }
        
        guard let requestDate = date.asDate(with: calendar) else { return nil }
        
        let requestWeekday = calendar.component(.weekday, from: requestDate)-1
        guard requestWeekday == self.weekday else { return false }
        
        guard requestDate >= fromDate else { return false }
        guard requestDate <= toDate else { return false }
        return true
    }
    
    func timeIntersects(with meeting: Meeting) -> Bool? {
        guard let lFromTime = self.fromTime else { return nil }
        guard let lToTime = self.toTime else { return nil }
        guard let rFromTime = meeting.fromTime else { return nil }
        guard let rToTime = meeting.toTime else { return nil }
        
        if lFromTime < rFromTime {
            return lToTime > rFromTime
        } else {
            return lFromTime < rToTime
        }
    }
    
    var duration: Time? {
        guard let from = self.fromTime else { return nil }
        guard let to = self.toTime else { return nil }
        return to - from
    }
    
    var weekdayTime: WeekdayTime? {
        guard let fromTime = self.fromTime else { return nil }
        return WeekdayTime(weekday: self.weekday, time: fromTime)
    }
}

extension Meeting: Identifiable { }

extension Meeting: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.type)
        hasher.combine(self.remark)
        hasher.combine(self.room)
        hasher.combine(self.online)
        hasher.combine(self.fromTime)
        hasher.combine(self.toTime)
        hasher.combine(self.frequency)
        hasher.combine(self.weekday)
        hasher.combine(self.fromDate)
        hasher.combine(self.toDate)
    }
    
    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        guard lhs.type == rhs.type else { return false }
        guard lhs.remark == rhs.remark else { return false }
        guard lhs.room == rhs.room else { return false }
        guard lhs.online == rhs.online else { return false }
        guard lhs.fromTime == rhs.fromTime else { return false }
        guard lhs.toTime == rhs.toTime else { return false }
        guard lhs.frequency == rhs.frequency else { return false }
        guard lhs.weekday == rhs.weekday else { return false }
        guard lhs.fromDate == rhs.fromDate else { return false }
        guard lhs.toDate == rhs.toDate else { return false }
        return true
    }
}
