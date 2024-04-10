//
//  InstructorsView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 09.04.24.
//

import SwiftUI

struct InstructorsView: View {
    var instructors: [Instructor]
    
    var body: some View {
        List(instructors) { instructor in
            Section {
                LabeledContent("Name", value: instructor.name)
                LabeledContent("Type", value: instructor.responsibility.description)
            } header: {
                Text("ID ") + Text(instructor.id, format: .number.grouping(.never))
            }
        }
        .navigationTitle("Event Instructors Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
