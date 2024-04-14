//
//  RoomType.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 14.04.24.
//

extension Room {
    enum RoomType: String {
        case lectureHall
        case seminarRoom
        case lab
        case computerLab
        case readingRoom
        case gym
        
        case dutyRoom
        case meetingRoom_
        case otherRoom
        
        case outdoorFacility
        case swimmingPool
        case sportsRoom
        case courseRoom
        
        
        case treatmentRoom
        case divers
        case foyer
        case multimediaCenter
        case eventRoom
    }
}

extension Room.RoomType: Decodable { }

extension Room.RoomType: CustomStringConvertible {
    var description: String {
        switch self {
        case .lectureHall: "Lecture Hall"
        case .seminarRoom: "Seminar Room"
        case .lab: "Lab"
        case .computerLab: "Computer Lab"
        case .readingRoom: "Reading Room"
        case .gym: "Gym"
        case .dutyRoom: "Duty Room"
        case .meetingRoom_: "Meeting Room_"
        case .otherRoom: "Other Room"
        case .outdoorFacility: "Outdoor Facility"
        case .swimmingPool: "Swimming Pool"
        case .sportsRoom: "Sports Room"
        case .courseRoom: "Course Room"
        case .treatmentRoom: "Treatment Room"
        case .divers: "Divers"
        case .foyer: "Foyer"
        case .multimediaCenter: "Multimedia Center"
        case .eventRoom: "Event Room"
        }
    }
}
