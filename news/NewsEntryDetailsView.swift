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
            VStack(alignment: .leading, spacing: 10) {
                Text(entry.title)
                    .font(.title)
                
                if let body = entry.body {
                    Text(body)
                }
            }
            .padding()
        }
    }
}
