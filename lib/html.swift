//
//  html.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 10.04.24.
//

import SwiftUI

extension AttributedString {
    init?(html: String, language: Locale.Language) throws {
        let html = html
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let utf8 = html.data(using: .utf8) else { return nil }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: NSNumber(value: NSUTF8StringEncoding),
        ]
        
        let nsAttrStr = try NSMutableAttributedString.init(data: utf8, options: options, documentAttributes: nil)
        nsAttrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: Self.defaultParagraphStyle, range: NSRange(location: 0, length: nsAttrStr.length))
        
        self.init(nsAttrStr)
        self.font = Self.defaultFont
        self.foregroundColor = Self.defaultForegroundColor
        self.languageIdentifier = language.languageCode?.identifier ?? language.minimalIdentifier
    }
    
    private static var defaultFont: Font { .body }
    private static var defaultForegroundColor: Color { .primary }
    
    private static var defaultParagraphStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.hyphenationFactor = 1
        return style
    }
}

extension String {
    func parseFriedoLinHTML() -> AttributedString? {
        do {
            return try .init(html: self, language: .init(languageCode: .german))
        } catch {
            print(error)
            return nil
        }
    }
}
