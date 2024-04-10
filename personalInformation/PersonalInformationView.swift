//
//  PersonalInformationView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 05.04.24.
//

import SwiftUI

struct PersonalInformationView: View {
    @APIFetchable var personalInformation: FetchableStatus<PersonalInformation>
    
    var body: some View {
        NavigationStack {
            Group {
                switch personalInformation {
                case .error:
                    errorView()
                case .loading:
                    loadingView()
                case .value(let value):
                    valueView(value: value)
                }
            }
            .refreshable {
                await _personalInformation.loadValue()
            }
            .navigationTitle("Personal Information")
        }
    }
    
    @ViewBuilder private func loadingView() -> some View {
        ScrollView {
            ProgressView()
        }
    }
    
    @ViewBuilder private func valueView(value: PersonalInformation) -> some View {
        Form {
            LabeledContent("Name", value: value.firstName + " " + value.lastName)
            
            Section("Registration") {
                LabeledContent("Matriculation Number", value: value.matriculationNumber, format: .number.grouping(.never))
                    .monospacedDigit()
                
                LabeledContent("URZ Login", value: value.username)
            }
        }
    }
    
    @ViewBuilder private func errorView() -> some View {
        ScrollView {
            VStack {
                Image(systemName: "exclamationmark.arrow.triangle.2.circlepath")
                    .font(.title)
                
                Text("Unable to load personal information.")
            }
        }
    }
}
