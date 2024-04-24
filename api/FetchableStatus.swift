//
//  FetchableStatus.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

@dynamicMemberLookup
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
    
    subscript<Member>(dynamicMember keyPath: KeyPath<Value, Member>) -> FetchableStatus<Member> {
        switch self {
        case .error: .error
        case .loading: .loading
        case .value(let value): .value(value[keyPath: keyPath])
        }
    }
}
