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
            VStack(alignment: .leading) {
                Text(instructor.name)
                
                if let responsibility = instructor.responsibility {
                    Text(responsibility.description)
                }
            }
        }
        .navigationTitle("Event Instructors Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
