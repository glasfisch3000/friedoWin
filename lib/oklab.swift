//
//  oklab.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 07.04.24.
//

import SwiftUI

extension Color {
    static func transformOklabToXYZ(oklabL: Double, A: Double, B: Double) -> (Double, Double, Double) {
        let l = oklabL + 0.3963377774 * A + 0.2158037573 * B
        let a = oklabL - 0.1055613458 * A - 0.0638541728 * B
        let b = oklabL - 0.0894841775 * A - 1.2914855480 * B

        let l3 = pow(l, 3)
        let a3 = pow(a, 3)
        let b3 = pow(b, 3)

        let x = 1.22701 * l3 - 0.5578 * a3 + 0.281256 * b3
        let y = -0.0405802 * l3 + 1.11226 * a3 - 0.0716767 * b3
        let z = -0.0763813 * l3 - 0.421482 * a3 + 1.58616 * b3

        return (x * 100, y * 100, z * 100)
    }
    
    static func transformXYZToRGB(X: Double, Y: Double, Z: Double) -> (Double, Double, Double) {
        let x = X / 100
        let y = Y / 100
        let z = Z / 100

        let r = 3.24096994 * x - 1.53738318 * y - 0.49861076 * z
        let g = -0.96924364 * x + 1.8759675 * y + 0.04155506 * z
        let b = 0.05563008 * x - 0.20397696 * y + 1.05697151 * z
        
        let adjustedR = min(max(gamma(r), 0), 1)
        let adjustedG = min(max(gamma(g), 0), 1)
        let adjustedB = min(max(gamma(b), 0), 1)

        return (adjustedR, adjustedG, adjustedB)
    }
    
    fileprivate static func gamma(_ component: Double) -> Double {
        if component <= 0.0031308 { return 12.92 * component }
        return 1.055 * pow(component, 1 / 2.4) - 0.055
    }
    
    init(oklabL: Double, a: Double, b: Double) {
        let (x, y, z) = Self.transformOklabToXYZ(oklabL: oklabL, A: a, B: b)
        let (red, green, blue) = Self.transformXYZToRGB(X: x, Y: y, Z: z)
        self.init(.sRGBLinear, red: red, green: green, blue: blue)
    }
    
    init(oklabL l: Double, chroma: Double, hash: Double) {
        let hf = hash * 2 * .pi
        let a = sin(hf) * chroma
        let b = cos(hf) * chroma
        
        self.init(oklabL: l, a: a, b: b)
    }
}
