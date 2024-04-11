//
//  FriedoWinServer.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import Foundation

extension FriedoWin {
    struct Server {
        var scheme: Scheme
        var domain: String
        var port: UInt16
        
        init(scheme: Scheme = .https, domain: String, port: UInt16 = 443) {
            self.scheme = scheme
            self.domain = domain
            self.port = port
        }
    }
    
    typealias Servers = [Server]
}

extension FriedoWin.Server: RawRepresentable {
    var constructed: String {
        "\(scheme.rawValue)://\(domain):\(port)"
    }
    
    var rawValue: String { self.constructed }
    
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

extension FriedoWin.Server: Hashable { }
extension FriedoWin.Server: Codable { }

extension FriedoWin.Server {
    enum Scheme: String {
        case http
        case https
    }
}

extension FriedoWin.Server.Scheme: Hashable { }
extension FriedoWin.Server.Scheme: Codable { }
extension FriedoWin.Server.Scheme: RawRepresentable { }
