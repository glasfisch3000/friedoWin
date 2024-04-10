//
//  EventType.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

extension Event {
    enum EventType: String, Decodable {
        case advancedSeminar
        case blockage
        case colloquium
        case consultation
        case exam
        case excursion
        case exercise
        case fieldExercise
        case languageCourse
        case lectureExercise
        case lecture
        case mainSeminar
        case optionalLecture
        case optionalSeminar
        case practicalWork
        case project
        case propaedeutic
        case proseminar
        case repeatExam
        case seminar
        case seminarExercise
        case training
        case trainingResearchProject
        case tutorial
    }
}

extension Event.EventType: CustomStringConvertible {
    var description: String {
        switch self {
        case .advancedSeminar: "Advanced Seminar"
        case .blockage: "Blockage"
        case .colloquium: "Colloquium"
        case .consultation: "Consultation"
        case .exam: "Exam"
        case .excursion: "Excursion"
        case .exercise: "Exercise"
        case .fieldExercise: "Field Exercise"
        case .languageCourse: "Language Course"
        case .lectureExercise: "Lecture Exercise"
        case .lecture: "Lecture"
        case .mainSeminar: "Main Seminar"
        case .optionalLecture: "Optional Lecture"
        case .optionalSeminar: "Optional Seminar"
        case .practicalWork: "Practical Work"
        case .project: "Project"
        case .propaedeutic: "Propaedeutic"
        case .proseminar: "Proseminar"
        case .repeatExam: "Repeat Exam"
        case .seminar: "Seminar"
        case .seminarExercise: "Seminar Exercise"
        case .training: "Training"
        case .trainingResearchProject: "Training Research Project"
        case .tutorial: "Tutorial"
        }
    }
}

extension Event.EventType {
    var isSecondary: Bool {
        switch self {
//        case .advancedSeminar:
//        case .blockage:
//        case .colloquium:
//        case .consultation:
//        case .exam:
//        case .excursion:
        case .exercise: return true
//        case .fieldExercise:
//        case .languageCourse:
//        case .lectureExercise:
        case .lecture: return false
//        case .mainSeminar:
//        case .optionalLecture:
//        case .optionalSeminar:
//        case .practicalWork:
//        case .project:
//        case .propaedeutic:
//        case .proseminar:
//        case .repeatExam:
//        case .seminar:
//        case .seminarExercise:
//        case .training:
//        case .trainingResearchProject:
//        case .tutorial:
        default: return false
        }
    }
}
