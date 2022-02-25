//
//  KeychainManager.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/9/21.
//

import Foundation

protocol KeychainManaging {
    func get(key: String) -> String?
    func set(key: String, value: String)
    func has(key: String) -> Bool
    func remove(key: String)
}

// swiftlint:disable force_unwrapping
final class KeychainManager: KeychainManaging {
    func has(key: String) -> Bool {
        get(key: key) == nil ?
            false :
            true
    }

    func get(key: String) -> String? {
        let rawData: Data? = Self.load(key: key)

        guard let data = rawData else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func set(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            return
        }

        Self.save(key: key, data: data)
    }

    func remove(key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecAttrSynchronizable: kCFBooleanTrue!
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Private methods
private extension KeychainManager {
    static func save(key: String, data: Data) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrSynchronizable: kCFBooleanTrue!
        ] as [String: Any]

        SecItemDelete(query as CFDictionary)

        SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrSynchronizable: kCFBooleanTrue!
        ] as [String: Any]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        return status == noErr ?
            // swiftlint:disable:next force_cast
            dataTypeRef as! Data? :
            nil
    }
}

// swiftlint:enable force_unwrapping
