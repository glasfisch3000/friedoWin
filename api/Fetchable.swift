//
//  Fetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import SwiftUI

@propertyWrapper
struct Fetchable<Source, Value>: DynamicProperty where Value: Decodable {
    typealias Status = FetchableStatus<Value>
    typealias Fetcher = (Source) async throws -> Value
    
    private var source: Source
    private var fetcher: Fetcher
    
    @State var error: Error? = nil
    @State var cachedValue: Value? = nil
    @State var loading: Bool = false
    
    @inlinable
    var wrappedValue: Status {
        if self.error != nil { return .error }
        if let value = self.cachedValue { return .value(value) }
        
        return .loading
    }
    
    var projectedValue: Source {
        get { self.source }
        set { self.source = newValue }
    }
    
    init(source: Source, fetcher: @escaping Fetcher) {
        self.source = source
        self.fetcher = fetcher
    }
    
    func loadValue() async {
        do {
            let value = try await fetcher(self.source)
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
