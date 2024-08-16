//
//  NewsEntryDetailsView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

import SwiftUI

struct NewsEntryDetailsView: View {
    var entry: NewsEntry
    
    @State private var expanded = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(entry.title)
                        .font(.title)
                        .bold()
                    
                    HStack(alignment: .center, spacing: 6) {
                        Group {
                            switch entry.source {
                            case .friedolin: Text("Friedolin News")
                            case .moodle: Text("Moodle Nachrichten")
                            case .fsrInformatik: Text("FSR Informatik")
                            }
                        }
                        .font(.caption)
                        .padding(.horizontal, 5.5)
                        .padding(.vertical, 1.5)
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.foreground, lineWidth: 0.7)
                        }
                        
                        Text("–")
                        
                        Text(entry.date, format: Date.FormatStyle(date: .complete, time: .omitted))
                    }
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    if let body = entry.body {
                        Text(body)
                        
                        if let link = entry.link {
                            Link(destination: link) {
                                (Text(Image(systemName: "safari")) + Text(" View full article"))
                                    .underline(true, pattern: .solid)
                            }
                        }
                    } else if let link = entry.link {
                        Link(destination: link) {
                            (Text(Image(systemName: "safari")) + Text(" View article"))
                                .underline(true, pattern: .solid)
                        }
                    }
                    
                    Text("Test")
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding()
        }
    }
}
