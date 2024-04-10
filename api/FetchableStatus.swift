//
//  FetchableStatus.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

enum FetchableStatus<Value> {
    case error
    case loading
    case value(_ value: Value)
    
    var value: Value? {
        switch self {
        case .value(let value): return value
        default: return nil
        }
    }
}
