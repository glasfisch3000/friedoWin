//
//  NewsView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

import SwiftUI

struct NewsView: View {
    @ServersFetchable var news: FetchableStatus<News>
    
    @State private var entryPresented: NewsEntry? = nil
    @ArrayAppStorage("news.read") private var newsRead = [String]()
    
    var body: some View {
        NavigationStack {
            Group {
                switch news {
                case .error:
                    errorView()
                case .loading:
                    loadingView()
                case .value(let news):
                    valueView(news)
                }
            }
            .refreshable {
                await _news.loadValue()
            }
            .navigationTitle("News")
            .sheet(item: $entryPresented) { entry in
                NavigationStack {
                    NewsEntryDetailsView(entry: entry)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    entryPresented = nil
                                }
                                .keyboardShortcut(.cancelAction)
                                .keyboardShortcut(.defaultAction)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .badge(news.value?.filter { !newsRead.contains($0.signature) }.count ?? 0)
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
                
                Text("Unable to load news.")
            }
        }
    }
    
    @ViewBuilder private func valueView(_ news: News) -> some View {
        if news.isEmpty {
            ScrollView {
                Text("No recent news.")
            }
        } else {
            List(news.sorted(using: KeyPathComparator(\.date, order: .reverse)), id: \.signature, rowContent: entryView(_:))
                .listSectionSpacing(.compact)
        }
    }
    
    @ViewBuilder private func entryView(_ entry: NewsEntry) -> some View {
        Section {
            let read = newsRead.contains(entry.signature)
            
            Button {
                entryPresented = entry
                DispatchQueue.main.async {
                    newsRead.append(entry.signature)
                }
            } label: {
                VStack(alignment: .leading, spacing: 7) {
                    VStack(alignment: .leading, spacing: 1.5) {
                        LabeledContent {
                            Text(entry.date, format: .relative(presentation: .named))
                                .font(.subheadline)
                        } label: {
                            HStack(alignment: .center) {
                                if !read {
                                    Image(systemName: "circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                                
                                Text(entry.title)
                                    .lineLimit(1)
                                    .font(.title3.weight(.semibold))
                            }
                        }
                        
                        Group {
                            switch entry.source {
                            case .friedolin: Text("Friedolin News")
                            case .moodle: Text("Moodle Nachrichten")
                            case .fsrInformatik: Text("FSR Informatik")
                            }
                        }
                        .font(.caption2)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.foreground, lineWidth: 0.5)
                        }
                    }
                    
                    if var body = entry.body {
                        let _ = body.swiftUI.font = .caption
                        Text(body)
                            .lineLimit(3)
                    }
                }
            }
            .buttonStyle(.plain)
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button(read ? "Unread" : "Read", systemImage: read ? "envelope.badge" : "envelope.open") {
                    if read {
                        newsRead.removeAll { $0 == entry.signature }
                    } else {
                        newsRead.append(entry.signature)
                    }
                }
                .tint(.blue)
            }
        }
    }
}
