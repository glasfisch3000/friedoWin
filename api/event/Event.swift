//
//  Event.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation
import Crypto
import UIKit

class Event: Decodable, ObservableObject {
    @Published var id: Int
    @Published var number: Int
    @Published var type: EventType
    @Published var name: String
    @Published var shortText: String
    @Published var links: [Event.Link]?
    
    @Published var content: AttributedString?
    @Published var literature: AttributedString?
    @Published var comment: AttributedString?
    @Published var prerequisites: AttributedString?
    
    @Published var term: Term
    @Published var weeklyHours: Double
    @Published var members1: Int
    @Published var members2: Int
    @Published var credits: Int?
    
    @Published var groups: [Group]?
    @Published var modules: [Event.Module]?
    @Published var instructors: [Instructor]?
    
    init(id: Int, number: Int, type: EventType, name: String, shortText: String, links: [Event.Link]?, content: AttributedString? = nil, literature: AttributedString? = nil, comment: AttributedString? = nil, prerequisites: AttributedString? = nil, term: Term, weeklyHours: Double, members1: Int, members2: Int, credits: Int? = nil, groups: [Group]? = nil, modules: [Event.Module]? = nil, instructors: [Instructor]? = nil) {
        self.id = id
        self.number = number
        self.type = type
        self.name = name
        self.shortText = shortText
        self.links = links
        self.content = content
        self.literature = literature
        self.comment = comment
        self.prerequisites = prerequisites
        self.term = term
        self.weeklyHours = weeklyHours
        self.members1 = members1
        self.members2 = members2
        self.credits = credits
        self.groups = groups
        self.modules = modules
        self.instructors = instructors
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.number = try container.decode(Int.self, forKey: .number)
        self.type = try container.decode(Event.EventType.self, forKey: .type)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortText = try container.decode(String.self, forKey: .shortText)
        self.links = try container.decodeIfPresent([Event.Link].self, forKey: .links)
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content)?.parseFriedoLinHTML()
        self.literature = try container.decodeIfPresent(String.self, forKey: .literature)?.parseFriedoLinHTML()
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment)?.parseFriedoLinHTML()
        self.prerequisites = try container.decodeIfPresent(String.self, forKey: .prerequisites)?.parseFriedoLinHTML()
        
        self.term = try container.decode(Term.self, forKey: .term)
        self.weeklyHours = try container.decode(Double.self, forKey: .weeklyHours)
        self.members1 = try container.decode(Int.self, forKey: .members1)
        self.members2 = try container.decode(Int.self, forKey: .members2)
        self.credits = try container.decodeIfPresent(Int.self, forKey: .credits)
        
        self.groups = try container.decodeIfPresent([Event.Group].self, forKey: .groups)
        self.modules = try container.decodeIfPresent([Event.Module].self, forKey: .modules)
        self.instructors = try container.decodeIfPresent([Instructor].self, forKey: .instructors)
    }
}

extension Event {
    enum CodingKeys: CodingKey {
        case id
        case number
        case type
        case name
        case shortText
        case links
        case content
        case literature
        case comment
        case prerequisites
        case term
        case weeklyHours
        case members1
        case members2
        case credits
        case groups
        case modules
        case instructors
    }
}

extension Event: Identifiable { }

extension Event {
    var firstOccurrence: WeekdayTime? {
        self.groups?.flatMap(\.meetings).reduce(nil) { result, meeting in
            guard let occurrence = meeting.weekdayTime else { return result }
            guard let result = result else { return occurrence }
            return min(occurrence, result)
        }
    }
    
    var sortableShortText: String {
        shortText.isEmpty ? name : shortText
    }
}

extension Event {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&publishid=\(self.id)&moduleCall=webInfo&publishConfFile=webInfo&publishSubDir=veranstaltung")
    }
}
