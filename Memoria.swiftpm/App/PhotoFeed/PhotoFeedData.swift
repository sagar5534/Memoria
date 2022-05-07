//
//  PhotoListData.swift
//  Memoria
//
//  Created by Sagar on 2021-08-31.
//

import Combine
import Foundation
import SwiftUI

class PhotoFeedData: ObservableObject {
    @Published var allMedia = MediaCollection()
    @Published var groupedMedia = SortedMediaCollection()
    @Published var isLoading = true
    @Published var isError = false

    private var cancellable: AnyCancellable?

    init() {
        fetchAllMedia()
    }

    func fetchAllMedia() {
        // Try a read
        if let data = JSONEncoder.loadJson(filename: "Output") {
            groupedMedia = data
            isLoading = false
        }

        MNetworking.sharedInstance.getMedia {
            print("Fetching all data")
        } completion: { [self] data, _, _ in
            guard data != nil else {
                isError = true
                return
            }
            let groupedDic = Dictionary(grouping: data!) { media -> String in
                media.modificationDate.toDate()!.toString(withFormat: "ddMMyyyy")
            }

            var groupedMedia = SortedMediaCollection()
            let keys = groupedDic.keys.sorted { first, second in
                first.toDate(withFormat: "ddMMyyyy")!.timeIntervalSince1970 > second.toDate(withFormat: "ddMMyyyy")!.timeIntervalSince1970
            }
            keys.forEach { key in
                groupedMedia.append(groupedDic[key]!)
            }

            if self.groupedMedia == groupedMedia {
                print("No refresh needed")
            } else {
                self.allMedia = data!
                self.groupedMedia = groupedMedia
                JSONEncoder.encode(from: groupedMedia)
            }
            
            withAnimation {
                self.isLoading = false
                self.isError = false
            }
            
        }
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

    static func loadJson(filename _: String) -> SortedMediaCollection? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = path.appendingPathComponent("Output.json")

//        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(SortedMediaCollection.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
//        }
        return nil
    }
}
