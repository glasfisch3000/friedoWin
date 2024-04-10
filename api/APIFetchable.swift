//
//  APIFetchable.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 06.04.24.
//

import SwiftUI

typealias APIFetchable<Value> = Fetchable<FriedoWin, Value> where Value: Decodable
