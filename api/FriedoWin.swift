//
//  FriedoWin.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 03.04.24.
//

import Foundation
import SwiftUI

class FriedoWin {
    struct Credentials: Hashable, Codable {
        var username: String
        var password: String
    }
    
    typealias Token = String
    
    var servers: [Server]
    var token: Token
    
    internal var reauthenticate: (() -> ())? = nil
    internal var friedoLinDown: (() -> ())? = nil
    
    init(servers: [Server], token: Token) {
        self.servers = servers
        self.token = token
    }
}
