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
    
    @Published var content: String?
    @Published var literature: String?
    @Published var comment: String?
    
    @Published var term: Term
    @Published var weeklyHours: Int
    @Published var members1: Int
    @Published var members2: Int
    @Published var credits: Int?
    
    @Published var groups: [Group]
    @Published var modules: [Event.Module]?
    @Published var instructors: [Instructor]
    
    init(id: Int, number: Int, type: EventType, name: String, shortText: String, content: String?, literature: String?, comment: String?, term: Term, weeklyHours: Int, members1: Int, members2: Int, credits: Int?, groups: [Group], modules: [Event.Module]?, instructors: [Instructor]) {
        self.id = id
        self.number = number
        self.type = type
        self.name = name
        self.shortText = shortText
        self.content = content
        self.literature = literature
        self.comment = comment
        self.term = term
        self.weeklyHours = weeklyHours
        self.members1 = members1
        self.members2 = members2
        self.credits = credits
        self.groups = groups
        self.modules = modules
        self.instructors = instructors
    }
}

extension Event: Identifiable { }

extension Event {
    var firstOccurrence: WeekdayTime? {
        self.groups.flatMap(\.meetings).reduce(nil) { result, meeting in
            let occurrence = meeting.weekdayTime
            
            guard let result = result else { return occurrence }
            return min(occurrence, result)
        }
    }
    
    var sortableShortText: String {
        shortText.isEmpty ? name : shortText
    }
}

extension Event {
    var parsedContent: AttributedString? {
        guard let content = content else { return nil }
        return try? .init(html: content)
    }
    
    var parsedLiterature: AttributedString? {
        guard let literature = literature else { return nil }
        return try? .init(html: literature)
    }
    
    var parsedComment: AttributedString? {
        guard let comment = comment else { return nil }
        return try? .init(html: comment)
    }
}

extension AttributedString {
    init?(html: String) throws {
        guard let utf8 = html.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: NSNumber(value: NSUTF8StringEncoding),
        ]
        let nsAttrStr = try NSAttributedString.init(data: utf8, options: options, documentAttributes: nil)
        
        self.init(nsAttrStr)
    }
}
