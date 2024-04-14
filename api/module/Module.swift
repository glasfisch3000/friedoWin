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
    
    @Published var credits: Int
    @Published var workloadPrivate: Int
    @Published var workloadClass: Int

    @Published var content: AttributedString?
    @Published var learningObjectives: AttributedString?
    
    init(id: Int, name: String, shortText: String, credits: Int, workloadPrivate: Int, workloadClass: Int, content: AttributedString? = nil, learningObjectives: AttributedString? = nil) {
        self.id = id
        self.name = name
        self.shortText = shortText
        self.credits = credits
        self.workloadPrivate = workloadPrivate
        self.workloadClass = workloadClass
        self.content = content
        self.learningObjectives = learningObjectives
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortText = try container.decode(String.self, forKey: .shortText)
        
        self.credits = try container.decode(Int.self, forKey: .credits)
        self.workloadPrivate = try container.decode(Int.self, forKey: .workloadPrivate)
        self.workloadClass = try container.decode(Int.self, forKey: .workloadClass)
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content)?.parseFriedoLinHTML()
        self.learningObjectives = try container.decodeIfPresent(String.self, forKey: .learningObjectives)?.parseFriedoLinHTML()
    }
}

extension Module {
    enum CodingKeys: CodingKey {
        case id
        case name
        case shortText
        case credits
        case workloadPrivate
        case workloadClass
        case content
        case learningObjectives
    }
}

extension Module: Identifiable { }

extension Module: Hashable {
    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.shortText == rhs.shortText &&
        lhs.credits == rhs.credits &&
        lhs.workloadPrivate == rhs.workloadPrivate &&
        lhs.workloadClass == rhs.workloadClass &&
        lhs.content == rhs.content &&
        lhs.learningObjectives == rhs.learningObjectives
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(shortText)
        hasher.combine(credits)
        hasher.combine(workloadPrivate)
        hasher.combine(workloadClass)
        hasher.combine(content)
        hasher.combine(learningObjectives)
    }
}

extension Module {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&moduleCall=PordDetail&publishConfFile=pord&publishSubDir=pord&pord.pordnr=\(self.id)")
    }
}
