
import Foundation
import UIKit

// MARK: - MediaElement

struct Collection: Decodable, Hashable {
    let month, year: Int
    let data: [[Media]]
}

// MARK: - Media

public struct Media: Decodable, Hashable {
    let id, name, creationDate, path: String
    let thumbnailPath: String
    let user: String
    let v: Int
    let isFavorite: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case creationDate = "creation_date"
        case path
        case thumbnailPath = "thumbnail_path"
        case user
        case isFavorite
        case v = "__v"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        creationDate = try values.decode(String.self, forKey: .creationDate)
        path = try values.decode(String.self, forKey: .path)
        thumbnailPath = try values.decode(String.self, forKey: .thumbnailPath)
        user = try values.decode(String.self, forKey: .user)
        v = try values.decode(Int.self, forKey: .v)
        isFavorite = try values.decode(Bool.self, forKey: .isFavorite)
    }
}

typealias MediaCollection = [Collection]
