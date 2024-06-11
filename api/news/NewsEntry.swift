//
//  NewsEntry.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

import Foundation

struct NewsEntry {
    typealias Date = Meeting.Date
    
    var date: Self.Date
    var title: String
    var body: AttributedString?
}

extension NewsEntry: Hashable { }
extension NewsEntry: Decodable {
    enum CodingKeys: CodingKey {
        case date
        case title
        case body
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try container.decode(Self.Date.self, forKey: .date)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body).parseFriedoLinHTML()
    }
}
