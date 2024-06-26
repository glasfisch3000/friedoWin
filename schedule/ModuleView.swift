//
//  ModuleView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 09.04.24.
//

import SwiftUI

struct ModuleView: View {
    @APIFetchable var module: FetchableStatus<Module>
    
    var body: some View {
        Group {
            switch module {
            case .error: errorView()
            case .loading: loadingView()
            case .value(let module): valueView(module)
            }
        }
        .refreshable {
            await _module.loadValue()
        }
        .navigationTitle("Module Info")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ScrollView {
            ProgressView()
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        ScrollView {
            VStack {
                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                    .font(.title)
                
                Text("Unable to load module.")
            }
        }
    }
    
    @ViewBuilder private func valueView(_ module: Module) -> some View {
        Form {
            Section {
                LabeledContent("Name", value: module.name)
                LabeledContent("Short Text", value: module.shortText)
                
                if let url = module.friedoLinURL {
                    Link("View on FriedoLin", destination: url)
                }
            }
            
            Section("Workload") {
                LabeledContent("Hours in Class", value: module.workloadClass, format: .number)
                LabeledContent("Hours in Private", value: module.workloadPrivate, format: .number)
                LabeledContent("Credits", value: module.credits, format: .number)
            }
            
            if let content = module.content {
                Section("Content") {
                    Text(content)
                }
            }
            
            if let literature = module.literature {
                Section("Literature") {
                    Text(literature)
                }
            }
            
            if let learningObjectives = module.learningObjectives {
                Section("Learning Objectives") {
                    Text(learningObjectives)
                }
            }
            
            if let examPrerequisites = module.examPrerequisites {
                Section("Exam Prerequisites") {
                    Text(examPrerequisites)
                }
            }
        }
    }
}
