//
//  published-decodable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 06.04.24.
//

import Foundation

extension Published: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self.init(initialValue: try .init(from: decoder))
    }
}
