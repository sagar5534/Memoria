
import Foundation
//import UIKit

// MARK: - Media

struct Media: Identifiable, Codable, Hashable {
    let id, path: String
    let source: Source
    let livePhotoPath, thumbnailPath: String?
    let isLivePhoto: Bool
    var isHidden, isFavorite: Bool?
    let duration: Double?
    let modificationDate, creationDate: String
    let mediaSubType: Int?
    let mediaType: MediaType?
    let assetID, filename: String
    let user: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case livePhotoPath = "livePhoto_path"
        case thumbnailPath = "thumbnail_path"
        case assetID = "assetId"
        case v = "__v"
        case filename, user, path, isLivePhoto, isHidden, isFavorite, duration, modificationDate, creationDate, mediaSubType, mediaType, source
    }
}

enum Source: String, Codable {
    case local = "LOCAL"
    case ios = "IOS"
}

enum MediaType: Int, Codable {
    case photo = 1
    case video = 2
}

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
    var source: Source
}
