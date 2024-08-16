//
//  NewsEntry.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

import Foundation

struct NewsEntry {
    enum NewsSource: String, Decodable {
        case friedolin
        case moodle
        case fsrInformatik
    }
    
    var articleID: String?
    var source: NewsSource
    
    var date: Date
    var title: String
    var link: URL?
    
    var body: AttributedString?
    var isPartial: Bool
}

extension NewsEntry: Hashable { }

extension NewsEntry: Identifiable {
    var id: String { signature }
}

extension NewsEntry: Decodable {
    enum CodingKeys: CodingKey {
        case id
        case source
        
        case date
        case title
        case link
        
        case body
        case partial
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.source = try container.decode(NewsSource.self, forKey: .source)
        self.articleID = try container.decodeIfPresent(String.self, forKey: .id)
        
        self.date = try container.decode(Date.self, forKey: .date)
        self.title = try container.decode(String.self, forKey: .title)
        self.link = try container.decodeIfPresent(URL.self, forKey: .link)
        
        self.body = try container.decode(String.self, forKey: .body).parseFriedoLinHTML()
        self.isPartial = try container.decode(Bool.self, forKey: .partial)
    }
}

extension NewsEntry {
    var signature: String { "\(source)/\(articleID ?? "")/\(date.timeIntervalSince1970)/\(title)" }
}
