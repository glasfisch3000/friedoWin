//
//  Instructor.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 09.04.24.
//

import Foundation

class Instructor: Decodable, ObservableObject {
    enum Responsibility: String, Decodable {
        case responsible
        case accompanying
        case organizational
    }
    
    @Published var id: Int
    @Published var name: String
    @Published var responsibility: Responsibility?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.responsibility = try container.decodeIfPresent(Instructor.Responsibility.self, forKey: .responsibility) // omitempty
    }
}

extension Instructor {
    enum CodingKeys: CodingKey {
        case id
        case name
        case responsibility
    }
}

extension Instructor: Identifiable { }
extension Instructor.Responsibility: Hashable { }

extension Instructor: Hashable {
    static func == (lhs: Instructor, rhs: Instructor) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.responsibility == rhs.responsibility
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(responsibility)
    }
}

extension Instructor.Responsibility: CustomStringConvertible {
    var description: String {
        switch self {
        case .responsible: "Responsible"
        case .accompanying: "Accompanying"
        case .organizational: "Organizational"
        }
    }
}
