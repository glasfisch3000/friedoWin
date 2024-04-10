//
//  TimetableItemView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 08.04.24.
//

import SwiftUI

struct TimetableItemView<Item>: View where Item: TimetableEntry {
    @Environment(\.colorScheme) var colorScheme
    
    var entry: Item
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            let color = entry.color(colorScheme: colorScheme)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .opacity(entry.isSecondary ? 0.5 : 1)
            
            if entry.isSecondary {
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 5, bottomLeading: 5, bottomTrailing: 0, topTrailing: 0))
                    .fill(color)
                    .frame(width: 4)
            }
            
            VStack(alignment: .leading) {
                Text(entry.title)
                    .font(.caption)
                    .bold()
                
                Text(entry.subtitle)
                    .font(.caption2)
            }
            .padding(.leading, entry.isSecondary ? 7 : 3)
            .padding(.trailing, 3)
            .padding(.vertical, 2)
        }
    }
}
