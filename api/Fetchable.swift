//
//  Fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 06.04.24.
//

import SwiftUI

@propertyWrapper
struct Fetchable<Value>: DynamicProperty where Value: Decodable {
    enum Status {
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
    
    private var api: FriedoWin
    private var fetcher: (FriedoWin) async throws -> Value
    
    @State var error: Error? = nil
    @State var cachedValue: Value? = nil
    @State var loading: Bool = false
    
    @inlinable
    var wrappedValue: Status {
        if self.error != nil { return .error }
        if let value = self.cachedValue { return .value(value) }
        
        return .loading
    }
    
    var projectedValue: FriedoWin {
        get { self.api }
        set { self.api = newValue }
    }
    
    init(api: FriedoWin, fetcher: @escaping (FriedoWin) async throws -> Value) {
        self.api = api
        self.fetcher = fetcher
    }
    
    func loadValue() async {
        do {
            let value = try await fetcher(self.api)
            self.cachedValue = value
            self.error = nil
        } catch {
            self.error = error
        }
    }
    
    func update() {
        guard !self.loading else { return }
        guard self.error == nil else { return }
        guard self.cachedValue == nil else { return }
        
        refresh()
    }
    
    func refresh() {
        Task {
            self.loading = true
            self.cachedValue = nil
            self.error = nil
            
            await loadValue()
            
            self.loading = false
        }
    }
}
