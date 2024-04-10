//
//  FriedoWinView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 05.04.24.
//

import SwiftUI

struct FriedoWinView: View {
    enum TabSelection: Hashable {
        case personalInformation
        case schedule
    }
    
    init(api: FriedoWin) {
        self.api = api
    }
    
    var api: FriedoWin
    
    @State private var selectedTab: TabSelection = .schedule
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PersonalInformationView(personalInformation: api.personalInformation)
                .tag(TabSelection.personalInformation)
                .tabItem {
                    Label("My Info", systemImage: "person.crop.circle")
                }
            
            ScheduleView(schedule: api.schedule)
                .tag(TabSelection.schedule)
                .tabItem {
                    Label("Timetable", systemImage: "calendar")
                }
        }
    }
}
