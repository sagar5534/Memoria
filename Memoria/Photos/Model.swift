
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

// public struct tableMetadata: Decodable, Hashable {
//    let id = ""
//    dynamic var account = ""
//    dynamic var assetLocalIdentifier = ""
//    dynamic var checksums = ""
//    dynamic var chunk: Bool = false
//    dynamic var classFile = ""
//    dynamic var commentsUnread: Bool = false
//    dynamic var contentType = ""
//    dynamic var creationDate = NSDate()
//    dynamic var dataFingerprint = ""
//    dynamic var date = NSDate()
//    dynamic var directory: Bool = false
//    dynamic var deleteAssetLocalIdentifier: Bool = false
//    dynamic var downloadURL = ""
//    dynamic var e2eEncrypted: Bool = false
//    dynamic var edited: Bool = false
//    dynamic var etag = ""
//    dynamic var etagResource = ""
//    dynamic var ext = ""
//    dynamic var favorite: Bool = false
//    dynamic var fileId = ""
//    dynamic var fileName = ""
//    dynamic var fileNameView = ""
//    dynamic var fileNameWithoutExt = ""
//    dynamic var hasPreview: Bool = false
//    dynamic var iconName = ""
//    dynamic var livePhoto: Bool = false
//    dynamic var mountType = ""
//    dynamic var note = ""
//    dynamic var ocId = ""
//    dynamic var ownerId = ""
//    dynamic var ownerDisplayName = ""
//    dynamic var path = ""
//    dynamic var permissions = ""
//    dynamic var quotaUsedBytes: Int64 = 0
//    dynamic var quotaAvailableBytes: Int64 = 0
//    dynamic var resourceType = ""
//    dynamic var richWorkspace: String?
//    dynamic var serverUrl = ""
//    dynamic var session = ""
//    dynamic var sessionError = ""
//    dynamic var sessionSelector = ""
//    dynamic var sessionTaskIdentifier: Int = 0
//    dynamic var sharePermissionsCollaborationServices: Int = 0
//    dynamic var size: Int64 = 0
//    dynamic var status: Int = 0
//    dynamic var trashbinFileName = ""
//    dynamic var trashbinOriginalLocation = ""
//    dynamic var trashbinDeletionTime = NSDate()
//    dynamic var uploadDate = NSDate()
//    dynamic var url = ""
//    dynamic var urlBase = ""
//    dynamic var user = ""
//    dynamic var userId = ""
// }

typealias MediaCollection = [Collection]
