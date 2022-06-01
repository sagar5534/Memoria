//
//  MKeychain.swift
//  Memoria
//
//  Created by Sagar R Patel on 2021-12-29.
//

import Foundation
import KeychainAccess

public class MKeychain {
    static let shared: MKeychain = .init()
    private let keychain: Keychain

    init() {
        print("Starting Keychain")
        keychain = Keychain(service: "com.memoria.tokens")
    }

    deinit {
        print("Stopping Keychain Services")
    }

    func getBearerToken() -> String? {
        return try? keychain.get("bearer_token")
    }

    func setBearerToken(token: String) {
        try? keychain.set(token, key: "bearer_token")
    }

    func getRefreshToken() -> String? {
        return try? keychain.get("refresh_token")
    }

    func setRefreshToken(token: String) {
        try? keychain.set(token, key: "refresh_token")
    }
}
