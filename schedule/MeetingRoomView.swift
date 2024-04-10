//
//  MeetingRoomView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

struct MeetingRoomView: View {
    var room: Meeting.Room
    
    var body: some View {
        Form {
            Section {
                LabeledContent("ID", value: room.id, format: .number.grouping(.never))
            }
            
            Section {
                LabeledContent("Room", value: room.name)
                LabeledContent("Building", value: room.buildingName)
            }
        }
        .navigationTitle("Room Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
