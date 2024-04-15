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
            LabeledContent {
                Text(room.shortName)
            } label: {
                VStack(alignment: .leading) {
                    Text(room.name)
                    
                    if room.additionalName != room.name {
                        Text(room.additionalName)
                            .font(.caption)
                    }
                }
            }
        }
        .navigationTitle("Building Rooms Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
