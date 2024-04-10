//
//  DividedView.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 06.04.24.
//

import SwiftUI

struct DividedView<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        _VariadicView.Tree(DividedLayout()) {
            content()
        }
    }
}

private struct DividedLayout: _VariadicView_MultiViewRoot {
    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        let last = children.last?.id

        ForEach(children) { child in
            child

            if child.id != last {
                Divider()
            }
        }
    }
}
