//
//  EventView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

struct EventView: View {
    @Fetchable var event: Fetchable<Event>.Status
    var colorHash: Double = 0.4
    
    var body: some View {
        Group {
            switch event {
            case .error: errorView()
            case .loading: loadingView()
            case .value(let value): valueView(value)
            }
        }
        .refreshable {
            await _event.loadValue()
        }
        .navigationTitle("Event Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ScrollView {
            ProgressView()
        }
    }
    
    @ViewBuilder private func valueView(_ event: Event) -> some View {
        Form {
            Section {
                LabeledContent("Title", value: event.name)
                if !event.shortText.isEmpty {
                    LabeledContent("Short Text", value: event.shortText)
                }
                
//                LabeledContent("ID", value: event.id, format: .number.grouping(.never))
                LabeledContent("Number", value: event.number, format: .number.grouping(.never))
                
                Link("View on FriedoLin", destination: URL(string: "https://friedolin.uni-jena.de/qisserver/rds?state=verpublish&publishid=\(event.id)&moduleCall=webInfo&publishConfFile=webInfo&publishSubDir=veranstaltung")!)
            }
            
            Section {
                LabeledContent("Type", value: event.type.description)
                if let credits = event.credits {
                    LabeledContent("Credits", value: credits, format: .number)
                }
                
                NavigationLink {
                    InstructorsView(instructors: event.instructors)
                } label: {
                    Text("Instructors")
                        .badge(event.instructors.count)
                        .badgeProminence(.decreased)
                }
            }
            
            Section {
                LabeledContent("Term", value: event.term.description)
                
                LabeledContent("Weekly Time", value: "\(event.weeklyHours)h")
                
                NavigationLink {
                    EventGroupsView(event: self._event, groups: event.groups, colorHash: colorHash)
                } label: {
                    Text("Groups")
                        .badge(event.groups.count)
                        .badgeProminence(.decreased)
                }
            }
            
            Section("Max. Members") {
                LabeledContent("First Run", value: event.members1, format: .number)
                LabeledContent("Second Run", value: event.members2, format: .number)
            }
            
            if let modules = event.modules {
                Section("Modules") {
                    ForEach(modules) { module in
                        NavigationLink {
                            ModuleView(module: $event.module(module.id))
                        } label: {
                            Text(module.name)
                                .lineLimit(1)
                        }
                    }
                }
            }
            
            if let content = event.parsedContent {
                Section("Content") {
                    Text(content)
                }
            }
            
            if let literature = event.parsedLiterature {
                Section("Literature") {
                    Text(literature)
                }
            }
            
            if let comment = event.parsedComment {
                Section("Comment") {
                    Text(comment)
                }
            }
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        ScrollView {
            VStack {
                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                    .font(.title)
                
                Text("Unable to load event.")
            }
        }
    }
}
