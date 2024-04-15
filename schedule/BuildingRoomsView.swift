//
//  BuildingRoomsView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 15.04.24.
//

import SwiftUI

struct BuildingRoomsView: View {
    var rooms: [Building.Room]
    
    var body: some View {
        List(rooms) { room in
            Section {
                LabeledContent("Name", value: room.name)
                LabeledContent("Short Name", value: room.shortName)
                
                if room.additionalName != room.name {
                    LabeledContent("Additional Name", value: room.additionalName)
                }
            } header: {
                Text("Room ") + Text(room.id, format: .number.grouping(.never))
            }
        }
        .navigationTitle("Building Rooms Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
