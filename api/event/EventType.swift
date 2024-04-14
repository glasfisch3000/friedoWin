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
        case basicCourse
        case basicModule
        case blockage
        case blockCourse
        case celebrationFestivity
        case colloquium
        case conference
        case conferenceSymposium
        case consultation
        case consulting
        case convention
        case course
        case course2
        case crosssectionalArea
        case exam
        case examTest
        case exhibition
        case excursion
        case exercise
        case exercises
        case fieldExercise
        case inauguralLecture
        case informationSession
        case languageCourse
        case lecture
        case lectureExercise
        case lecturePracticalWork
        case lectureSeminar
        case lectureSeries
        case mainSeminar
        case meeting
        case miscellaneous
        case movieScreening
        case musicalEvent
        case onlineLecture
        case onlineSeminar
        case optionalLecture
        case optionalSeminar
        case otherEvent
        case practiceModule
        case practicalSemesterAccompanyingEvent
        case practicalWork
        case practicalWorkSeminar
        case project
        case propaedeutic
        case proseminar
        case repeatExam
        case revisionCourse
        case sample
        case seminar
        case seminarExcursion
        case seminarExercise
        case serviceTime
        case session
        case speech
        case summerSchool
        case talk
        case teleteaching
        case tour
        case training
        case trainingResearchProject
        case tutorial
        case tutorial2
        case workingGroup
        case workshop
        case workshop2
    }
}

extension Event.EventType: CustomStringConvertible {
    var description: String {
        switch self {
        case .advancedModule: "Advanced Module"
        case .advancedSeminar: "Advanced Seminar"
        case .basicCourse: "Basic Course"
        case .basicModule: "Basic Module"
        case .blockage: "Blockage"
        case .blockCourse: "Block Course"
        case .celebrationFestivity: "Celebration Festivity"
        case .colloquium: "Colloquium"
        case .conference: "Conference"
        case .conferenceSymposium: "Conference Symposium"
        case .consultation: "Consultation"
        case .consulting: "Consulting"
        case .convention: "Convention"
        case .course: "Course"
        case .course2: "Course"
        case .crosssectionalArea: "Crosssectional Area"
        case .exam: "Exam"
        case .examTest: "Exam Test"
        case .excursion: "Excursion"
        case .exercise: "Exercise"
        case .exercises: "Exercises"
        case .exhibition: "Exhibition"
        case .fieldExercise: "Field Exercise"
        case .inauguralLecture: "Inaugural Lecture"
        case .informationSession: "Informational Session"
        case .languageCourse: "Language Course"
        case .lecture: "Lecture"
        case .lectureExercise: "Lecture Exercise"
        case .lecturePracticalWork: "Lecture Practical Work"
        case .lectureSeminar: "Lecture Seminar"
        case .lectureSeries: "Lecture Series"
        case .mainSeminar: "Main Seminar"
        case .meeting: "Meeting"
        case .miscellaneous: "Miscallaneous"
        case .movieScreening: "Movie Screening"
        case .musicalEvent: "Musical Event"
        case .onlineLecture: "Online Lecture"
        case .onlineSeminar: "Online Seminar"
        case .optionalLecture: "Optional Lecture"
        case .optionalSeminar: "Optional Seminar"
        case .otherEvent: "Other Event"
        case .practicalSemesterAccompanyingEvent: "Practical Semester Accompanying Event"
        case .practicalWork: "Practical Work"
        case .practicalWorkSeminar: "PracticalWorkSeminar"
        case .practiceModule: "Practice Module"
        case .project: "Project"
        case .propaedeutic: "Propaedeutic"
        case .proseminar: "Proseminar"
        case .repeatExam: "Repeat Exam"
        case .revisionCourse: "Revision Course"
        case .sample: "Sample"
        case .seminar: "Seminar"
        case .seminarExcursion: "Seminar Excursion"
        case .seminarExercise: "Seminar Exercise"
        case .serviceTime: "Service Time"
        case .session: "Session"
        case .speech: "Speech"
        case .summerSchool: "Summer School"
        case .talk: "Talk"
        case .teleteaching: "Teleteaching"
        case .tour: "Tour"
        case .training: "Training"
        case .trainingResearchProject: "Training Research Project"
        case .tutorial: "Tutorial"
        case .tutorial2: "Tutorial"
        case .workingGroup: "Working Group"
        case .workshop: "Workshop"
        case .workshop2: "Workshop"
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
