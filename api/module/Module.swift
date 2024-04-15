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
    @Published var literature: AttributedString?
    @Published var learningObjectives: AttributedString?
    @Published var examPrerequisites: AttributedString?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.shortText = try container.decode(String.self, forKey: .shortText)
        
        self.credits = try container.decode(Int.self, forKey: .credits)
        self.workloadPrivate = try container.decode(Int.self, forKey: .workloadPrivate)
        self.workloadClass = try container.decode(Int.self, forKey: .workloadClass)
        
        self.content = try container.decodeIfPresent(String.self, forKey: .content)?.parseFriedoLinHTML()
        self.literature = try container.decodeIfPresent(String.self, forKey: .literature)?.parseFriedoLinHTML()
        self.learningObjectives = try container.decodeIfPresent(String.self, forKey: .learningObjectives)?.parseFriedoLinHTML()
        self.examPrerequisites = try container.decodeIfPresent(String.self, forKey: .examPrerequisites)?.parseFriedoLinHTML()
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
        case literature
        case learningObjectives
        case examPrerequisites
    }
}

extension Module: Identifiable { }

extension Module: Hashable {
    static func == (lhs: Module, rhs: Module) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Module {
    var friedoLinURL: URL? {
        URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&moduleCall=PordDetail&publishConfFile=pord&publishSubDir=pord&pord.pordnr=\(self.id)")
    }
}
