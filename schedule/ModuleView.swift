//
//  ModuleView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 09.04.24.
//

import SwiftUI

struct ModuleView: View {
    @Fetchable var module: Fetchable<Module>.Status
    
    var body: some View {
        Group {
            switch module {
            case .error: errorView()
            case .loading: loadingView()
            case .value(let module): valueView(module)
            }
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
                LabeledContent("ID", value: module.id, format: .number.grouping(.never))
                LabeledContent("Name", value: module.name)
                LabeledContent("Short Text", value: module.shortText)
            }
            
            Section("Workload") {
                LabeledContent("Hours in Class", value: module.workloadClass, format: .number)
                LabeledContent("Hours in Private", value: module.workloadPrivate, format: .number)
                LabeledContent("Credits", value: module.points, format: .number)
            }
            
            if let content = module.parsedContent {
                Section("Content") {
                    Text(content)
                }
            }
            
            if let learningOutcomes = module.parsedLearningOutcomes {
                Section("Learning Outcomes") {
                    Text(learningOutcomes)
                }
            }
        }
    }
}
