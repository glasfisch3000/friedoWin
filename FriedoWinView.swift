//
//  FriedoWinView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 05.04.24.
//

import SwiftUI

struct FriedoWinView: View {
    var api: FriedoWin
    
    var body: some View {
        PersonalInformationView(personalInformation: api.personalInformation)
            .tag(ContentView.TabSelection.personalInformation)
            .tabItem {
                Label("My Info", systemImage: "person.crop.circle")
            }
        
        ScheduleView(schedule: api.schedule)
            .tag(ContentView.TabSelection.schedule)
            .tabItem {
                Label("Timetable", systemImage: "calendar")
            }
    }
}
