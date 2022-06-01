//
//  PhotoListData.swift
//  Memoria
//
//  Created by Sagar on 2021-08-31.
//

import Alamofire
import Combine
import Foundation
import SwiftUI
class HomeModel: ObservableObject {
//    @Published var allMedia = MediaCollection()
    @Published var groupedMedia: [[Media]] = []
    @Published var albumMedia: [String: [Media]] = [:]
    @Published var isLoading = true
    @Published var isError = false

    private var service = Service.shared
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        fetchAllMedia()
    }

    func fetchAllMedia() {
        // Try a read
        if let data = JSONEncoder.loadJson(filename: "Output") {
            groupedMedia = data
            isLoading = false
        }

        let publisher = service.fetchAllMedia()
            .share()

        publisher.sink { response in
            self.isLoading = false

            guard response.error == nil else {
                self.isError = true
                return
            }

            let groupedDic = Dictionary(grouping: response.value!) { media in
                media.modificationDate.toDate()!.toString(withFormat: "yyyyMMdd")
            }
            let keys = groupedDic.keys.sorted().reversed()
            var groupedMedia = [[Media]]()
            keys.forEach { key in
                groupedMedia.append(groupedDic[key]!)
            }
            self.groupedMedia = groupedMedia
            JSONEncoder.encode(from: groupedMedia)
        }
        .store(in: &cancellableSet)

        publisher.sink { response in
            guard response.error == nil else { return }

            let albumDic = Dictionary(grouping: response.value!) { media in
                media.path.split(separator: "/").first!.description
            }
            self.albumMedia = albumDic
        }
        .store(in: &cancellableSet)
    }

    func json(from object: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

extension JSONEncoder {
    static func encode<T: Encodable>(from data: T) {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let json = try jsonEncoder.encode(data)
            let jsonString = String(data: json, encoding: .utf8)

            saveToDocumentDirectory(jsonString)

        } catch {
            print(error.localizedDescription)
        }
    }

    private static func saveToDocumentDirectory(_ jsonString: String?) {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = path.appendingPathComponent("Output.json")

        do {
            try jsonString?.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }

    static func loadJson(filename _: String) -> [[Media]]? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = path.appendingPathComponent("Output.json")

//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([[Media]].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
//        }
        return nil
    }
}
