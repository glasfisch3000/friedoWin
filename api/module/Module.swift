//
//  Module.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 09.04.24.
//

import Foundation

class Module: Decodable, ObservableObject {
    @Published var id: Int
    @Published var name: String
    @Published var shortText: String
    
    @Published var points: Int
    @Published var workloadPrivate: Int
    @Published var workloadClass: Int

    @Published var content: String?
    @Published var learningOutcomes: String?
    
    init(id: Int, name: String, shortText: String, points: Int, workloadPrivate: Int, workloadClass: Int, content: String?, learningOutcomes: String?) {
        self.id = id
        self.name = name
        self.shortText = shortText
        self.points = points
        self.workloadPrivate = workloadPrivate
        self.workloadClass = workloadClass
        self.content = content
        self.learningOutcomes = learningOutcomes
    }
}

extension Module: Identifiable { }

extension Module: Hashable {
    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.shortText == rhs.shortText &&
        lhs.points == rhs.points &&
        lhs.workloadPrivate == rhs.workloadPrivate &&
        lhs.workloadClass == rhs.workloadClass &&
        lhs.content == rhs.content &&
        lhs.learningOutcomes == rhs.learningOutcomes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(shortText)
        hasher.combine(points)
        hasher.combine(workloadPrivate)
        hasher.combine(workloadClass)
        hasher.combine(content)
        hasher.combine(learningOutcomes)
    }
}

extension Module {
    var parsedContent: AttributedString? {
        guard let content = content else { return nil }
        return try? .init(html: content)
    }
    
    var parsedLearningOutcomes: AttributedString? {
        guard let learningOutcomes = learningOutcomes else { return nil }
        return try? .init(html: learningOutcomes)
    }
}
