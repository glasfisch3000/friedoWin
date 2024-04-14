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
                  links: additional.links,
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
    struct AdditionalInformation {
        var shortText: String
        var links: [Event.Link]?
        
        var content: AttributedString?
        var literature: AttributedString?
        var comment: AttributedString?
        
        var weeklyHours: Double
        var members1: Int
        var members2: Int
        var credits: Int?
        
        var modules: [Event.Module]?
        var instructors: [Instructor]
    }
}

extension Event.ScheduleEvent.AdditionalInformation: Decodable {
    enum CodingKeys: CodingKey {
        case shortText
        case links
        case content
        case literature
        case comment
        case weeklyHours
        case members1
        case members2
        case credits
        case modules
        case instructors
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        
        self.shortText = try container.decode(String.self, forKey: .shortText)
        self.links = try container.decodeIfPresent([Event.Link].self, forKey: .links)
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content)?.parseFriedoLinHTML()
        self.literature = try container.decodeIfPresent(String.self, forKey: .literature)?.parseFriedoLinHTML()
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)?.parseFriedoLinHTML()
        
        self.weeklyHours = try container.decode(Double.self, forKey: .weeklyHours)
        self.members1 = try container.decode(Int.self, forKey: .members1)
        self.members2 = try container.decode(Int.self, forKey: .members2)
        self.credits = try container.decodeIfPresent(Int.self, forKey: .credits)
        
        self.modules = try container.decodeIfPresent([Event.Module].self, forKey: .modules)
        self.instructors = try container.decode([Instructor].self, forKey: .instructors)
    }
}
