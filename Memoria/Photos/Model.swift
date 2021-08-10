
import Foundation

// MARK: - MediaElement

struct Collection: Codable, Hashable {
    let month, year: Int
    let data: [[Media]]
}

// MARK: - Datum

struct Media: Codable, Hashable {
    let id, name, dateCreated, dateModified, path: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case v = "__v"
        case path
    }
}

typealias MediaCollection = [Collection]
