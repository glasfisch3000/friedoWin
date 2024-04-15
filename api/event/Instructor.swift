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
    @Published var responsibility: Responsibility
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
