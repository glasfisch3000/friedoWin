//
//  fetch.swift
//  friedoWin
//
//  Created by Jakob Danckwerts on 04.04.24.
//

import Foundation
import Security

extension Keychain {
    enum FetchError: Error {
        case unexpectedData
        case missingUsername
        case missingPassword
        case unableToDecodePassword
        case other(status: OSStatus)
    }
    
    func fetchItem(for server: String) throws -> Credentials? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { return nil }
        guard status == errSecSuccess else { throw FetchError.other(status: status) }
        
        guard let existingItem = item as? [String : Any] else { throw FetchError.unexpectedData }
        guard let account = existingItem[kSecAttrAccount as String] as? String else { throw FetchError.missingUsername }
        
        guard let passwordData = existingItem[kSecValueData as String] as? Data else { throw FetchError.missingPassword }
        guard let password = String(data: passwordData, encoding: String.Encoding.utf8) else { throw FetchError.unableToDecodePassword }
        
        return Credentials(username: account, password: password)
    }
}
