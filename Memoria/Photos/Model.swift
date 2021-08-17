
import Foundation

// MARK: - MediaElement

struct Collection: Codable, Hashable {
    let month, year: Int
    let data: [[Media]]
}

// MARK: - Datum

struct Media: Codable, Hashable {
    let id, name, creationDate, path: String
    let thumbnailPath: String
    let user: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case creationDate = "creation_date"
        case path
        case thumbnailPath = "thumbnail_path"
        case user
        case v = "__v"
    }
}

// enum User: String, Codable {
//    case id = ""
// }

typealias MediaCollection = [Collection]
