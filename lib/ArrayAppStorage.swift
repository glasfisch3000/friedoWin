//
//  ArrayAppStorage.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 11.06.24.
//

import SwiftUI

@propertyWrapper
struct ArrayAppStorage<Value>: DynamicProperty {
    var key: String
    var userDefaults: UserDefaults = .standard
    
    var wrappedValue: [Value] {
        get {
            cachedValue
        }
        nonmutating set {
            userDefaults.set(newValue, forKey: key)
            cachedValue = newValue
        }
    }
    
    @State private var cachedValue: [Value]
    
    init(wrappedValue: [Value], _ key: String) {
        self.key = key
        self.cachedValue = (userDefaults.object(forKey: key) as? [Value]) ?? wrappedValue
        
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: .main, using: self.receive(_:))
    }
    
    func receive(_ notification: Notification) {
        guard let object = notification.object else { return }
        guard let userDefaults = object as? UserDefaults else { return }
        guard userDefaults == self.userDefaults else { return }
        
        guard let value = loadValue() else { return }
        self.cachedValue = value
    }
    
    private func loadValue() -> [Value]? {
        guard let array = userDefaults.object(forKey: key) else { return nil }
        guard let value = array as? [Value] else { return nil }
        return value
    }
}
