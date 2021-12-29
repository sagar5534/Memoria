//
//  MCommResponses.swift
//  Memoria
//
//  Created by Sagar R Patel on 2021-12-29.
//

import Foundation

// MARK: - RefreshToken

struct RefreshToken: Codable {
    let status: String
    let data: DataClass
}

struct DataClass: Codable {
    let user: User
    let payload: Payload
}

struct Payload: Codable {
    let type, token: String
}

struct User: Codable {
    let id, password, username: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case password, username
        case v = "__v"
    }
}
