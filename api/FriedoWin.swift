//
//  FriedoWin.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 03.04.24.
//

import Foundation
import SwiftUI

class FriedoWin {
    struct Server: Hashable, RawRepresentable, Codable {
        enum Scheme: String, RawRepresentable, Hashable, Codable {
            case http
            case https
        }
        
        var scheme: Scheme
        var domain: String
        var port: UInt16
        
        var constructed: String {
            "\(scheme.rawValue)://\(domain):\(port)"
        }
        
        var rawValue: String { self.constructed }
        
        init(scheme: Scheme = .https, domain: String, port: UInt16 = 443) {
            self.scheme = scheme
            self.domain = domain
            self.port = port
        }
        
        init?(rawValue: String) {
            let regex = /(?<scheme>https?):\/\/(?<domain>([A-Za-z0-9-]+\.)+[A-Za-z])(:(?<port>[0-9]+))?/
            guard let match = try? regex.wholeMatch(in: rawValue) else { return nil }
            
            guard let scheme = Scheme(rawValue: String(match.output.scheme)) else { return nil }
            self.scheme = scheme
            self.domain = String(match.output.domain)
            
            if let portString = match.output.port {
                guard let port = UInt16(String(portString)) else { return nil }
                self.port = port
            } else {
                self.port = 443
            }
        }
    }
    
    struct Credentials: Hashable, Codable {
        var username: String
        var password: String
    }
    
    typealias Token = String
    
    var servers: [Server]
    var token: Token
    
    internal var reauthenticate: (() -> ())? = nil
    
    init(servers: [Server], token: Token) {
        self.servers = servers
        self.token = token
    }
}
