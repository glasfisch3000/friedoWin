//
//  NewsEntry.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

import Foundation

struct NewsEntry {
    var date: NewsDate
    var title: String
    var body: AttributedString?
}

extension NewsEntry {
    struct NewsDate: Hashable, Codable {
        var day: Int
        var month: Int
        var year: Int
    }
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
        
        self.date = try container.decode(NewsDate.self, forKey: .date)
        self.title = try container.decode(String.self, forKey: .title)
        self.body = try container.decode(String.self, forKey: .body).parseFriedoLinHTML()
    }
}
