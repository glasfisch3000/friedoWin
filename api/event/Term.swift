//
//  Term.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import Foundation

struct Term: Decodable {
    enum Season: String, Decodable {
        case summer
        case winter
    }
    
    var season: Season
    var year: Int
}

extension Term.Season: Hashable { }
extension Term: Hashable { }

extension Term.Season: CustomStringConvertible {
    var description: String {
        switch self {
        case .summer: "SoSe"
        case .winter: "WiSe"
        }
    }
}

extension Term: CustomStringConvertible {
    var description: String {
        season.description + " " + IntegerFormatStyle().grouping(.never).format(year)
    }
}
