//
//  add.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 05.04.24.
//

import Foundation
import Security

extension Keychain {
    enum AddError: Error {
        case unableToEncodePassword
        case other(status: OSStatus)
    }
    
    func addItem(_ credentials: Credentials, for server: String) throws {
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)
        guard let password = password else { throw AddError.unableToEncodePassword }
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw AddError.other(status: status) }
    }
}
