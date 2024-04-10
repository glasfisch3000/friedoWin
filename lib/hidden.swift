//
//  hidden.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 04.04.24.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ condition: Bool) -> some View {
        if condition {
            self.hidden()
        } else {
            self
        }
    }
}
