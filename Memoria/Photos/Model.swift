
import Foundation
import UIKit

// MARK: - Collection

struct Collection: Decodable, Hashable {
    let month, year: Int
    let data: [[Media]]
}

typealias MediaCollection = [Collection]

// MARK: - Media

struct Media: Decodable, Hashable {
    let id, name, creationDate, path: String
    let thumbnailPath: String
    let user: String
    let v: Int
    var isFavorite: Bool

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

// MARK: - AssetIds

typealias AssetCollection = [String]

// MARK: - FileUpload

struct FileUpload {
    var url: URL?
    var livePhotoUrl: URL?

    var assetId: String
    var filename: String

    var mediaType: Int
    var mediaSubType: Int

    var creationDate: Date
    var modificationDate: Date

    var duration: Double

    var isFavorite: Bool
    var isHidden: Bool
    var isLivePhoto: Bool
}
