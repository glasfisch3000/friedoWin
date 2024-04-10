//
//  Meeting.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

class Meeting: Decodable, ObservableObject {
    @Published var type: Event.EventType? = nil
    @Published var remark: String?
    @Published var room: Room
    @Published var online: Bool
    
    @Published var fromTime: Time
    @Published var toTime: Time
    
    @Published var frequency: Frequency
    @Published var weekday: Int
    @Published var fromDate: Meeting.Date
    @Published var toDate: Meeting.Date
    
    init(type: Event.EventType? = nil, remark: String?, room: Meeting.Room, online: Bool, fromTime: Time, toTime: Time, frequency: Frequency, weekday: Int, fromDate: Meeting.Date, toDate: Meeting.Date) {
        self.type = type
        self.remark = remark
        self.room = room
        self.online = online
        self.fromTime = fromTime
        self.toTime = toTime
        self.frequency = frequency
        self.weekday = weekday
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try? container.decode(Event.EventType.self, forKey: .type)
        self.remark = try container.decode(String?.self, forKey: .remark)
        self.room = try container.decode(Meeting.Room.self, forKey: .room)
        self.online = try container.decode(Bool.self, forKey: .online)
        self.fromTime = try container.decode(Meeting.Time.self, forKey: .fromTime)
        self.toTime = try container.decode(Meeting.Time.self, forKey: .toTime)
        self.frequency = try container.decode(Frequency.self, forKey: .frequency)
        self.weekday = try container.decode(Int.self, forKey: .weekday)
        self.fromDate = try container.decode(Meeting.Date.self, forKey: .fromDate)
        self.toDate = try container.decode(Meeting.Date.self, forKey: .toDate)
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
    
    func timeIntersects(with meeting: Meeting) -> Bool {
        if self.fromTime < meeting.fromTime {
            return self.toTime > meeting.fromTime
        } else {
            return self.fromTime < meeting.toTime
        }
    }
    
    var duration: Time {
        self.toTime - self.fromTime
    }
    
    var weekdayTime: WeekdayTime {
        .init(weekday: self.weekday, time: self.fromTime)
    }
}

extension Meeting: Identifiable { }

extension Meeting {
    enum CodingKeys: CodingKey {
        case type
        case remark
        case room
        case online
        
        case fromTime
        case toTime
        
        case frequency
        case weekday
        case fromDate
        case toDate
    }
}

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

extension Meeting {
    var parsedRemark: AttributedString? {
        guard let remark = remark else { return nil }
        return try? .init(html: remark)
    }
}
