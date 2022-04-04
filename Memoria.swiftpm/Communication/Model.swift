
import Foundation
import UIKit

// MARK: - Media

struct Media: Encodable, Decodable, Hashable {
    let id, livePhotoPath, thumbnailPath, path: String
    let isLivePhoto: Bool
    var isHidden, isFavorite: Bool?
    let duration: Double?
    let modificationDate, creationDate: String
    let mediaSubType, mediaType: Int
    let assetID, filename: String
    let user: String
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case livePhotoPath = "livePhoto_path"
        case thumbnailPath = "thumbnail_path"
        case path, isLivePhoto, isHidden, isFavorite, duration, modificationDate, creationDate, mediaSubType, mediaType
        case assetID = "assetId"
        case filename, user
        case v = "__v"
    }
}

typealias MediaCollection = [Media]
typealias SortedMediaCollection = [[Media]]

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
