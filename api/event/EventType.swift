//
//  EventType.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

extension Event {
    enum EventType: String, Decodable {
        case advancedModule
        case advancedSeminar
        case basicModule
        case blockage
        case blockCourse
        case colloquium
        case consultation
        case consulting
        case course
        case crosssectionalArea
        case exam
        case excursion
        case exercise
        case fieldExercise
        case languageCourse
        case lecture
        case lectureExercise
        case lecturePracticalWork
        case lectureSeminar
        case mainSeminar
        case miscellaneous
        case movieScreening
        case optionalLecture
        case optionalSeminar
        case practiceModule
        case practicalWork
        case practicalWorkSeminar
        case project
        case propaedeutic
        case proseminar
        case repeatExam
        case revisionCourse
        case seminar
        case seminarExercise
        case teleteaching
        case training
        case trainingResearchProject
        case tutorial
        case workingGroup
        case workshop
    }
}

extension Event.EventType: CustomStringConvertible {
    var description: String {
        switch self {
        case .advancedModule: "Advanced Module"
        case .advancedSeminar: "Advanced Seminar"
        case .basicModule: "Basic Module"
        case .blockage: "Blockage"
        case .blockCourse: "Block Course"
        case .colloquium: "Colloquium"
        case .consultation: "Consultation"
        case .consulting: "Consulting"
        case .course: "Course"
        case .crosssectionalArea: "Crosssectional Area"
        case .exam: "Exam"
        case .excursion: "Excursion"
        case .exercise: "Exercise"
        case .fieldExercise: "Field Exercise"
        case .languageCourse: "Language Course"
        case .lecture: "Lecture"
        case .lectureExercise: "Lecture Exercise"
        case .lecturePracticalWork: "Lecture Practical Work"
        case .lectureSeminar: "Lecture Seminar"
        case .mainSeminar: "Main Seminar"
        case .miscellaneous: "Miscallaneous"
        case .movieScreening: "Movie Screening"
        case .optionalLecture: "Optional Lecture"
        case .optionalSeminar: "Optional Seminar"
        case .practicalWork: "Practical Work"
        case .practicalWorkSeminar: "PracticalWorkSeminar"
        case .practiceModule: "Practice Module"
        case .project: "Project"
        case .propaedeutic: "Propaedeutic"
        case .proseminar: "Proseminar"
        case .repeatExam: "Repeat Exam"
        case .revisionCourse: "Revision Course"
        case .seminar: "Seminar"
        case .seminarExercise: "Seminar Exercise"
        case .teleteaching: "Teleteaching"
        case .training: "Training"
        case .trainingResearchProject: "Training Research Project"
        case .tutorial: "Tutorial"
        case .workingGroup: "Working Group"
        case .workshop: "Workshop"
        }
    }
}

extension Event.EventType {
    var isSecondary: Bool {
        switch self {
        case .exercise: return true
        case .lecture: return false
        default: return false
        }
    }
}
