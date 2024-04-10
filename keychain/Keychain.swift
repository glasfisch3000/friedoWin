//
//  Keychain.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 05.04.24.
//

import Foundation

enum Keychain {
    case `default`
    
    struct Credentials {
        var username: String
        var password: String
    }
}
