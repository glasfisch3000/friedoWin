//
//  ScheduleEvent.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension Event {
    struct ScheduleEvent: Decodable {
        var id: Int
        var number: Int
        var type: EventType
        var name: String
        
        var term: Term
        
        var groups: [Group]
        
        func construct(with additional: AdditionalInformation) -> Event {
            .init(id: self.id,
                  number: self.number,
                  type: self.type,
                  name: self.name,
                  shortText: additional.shortText,
                  content: additional.content,
                  literature: additional.literature,
                  comment: additional.comment,
                  term: self.term,
                  weeklyHours: additional.weeklyHours,
                  members1: additional.members1,
                  members2: additional.members2,
                  credits: additional.credits,
                  groups: self.groups,
                  modules: additional.modules,
                  instructors: additional.instructors)
        }
    }
}

extension Event.ScheduleEvent {
    struct AdditionalInformation: Decodable {
        var shortText: String
        
        var content: String?
        var literature: String?
        var comment: String?
        
        var weeklyHours: Int
        var members1: Int
        var members2: Int
        var credits: Int?
        
        var modules: [Event.Module]?
        var instructors: [Instructor]
    }
}
