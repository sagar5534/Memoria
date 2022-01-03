//
//  PhotoListData.swift
//  Memoria
//
//  Created by Sagar on 2021-08-31.
//

import Combine
import Foundation

class PhotoGridData: ObservableObject {
    @Published var allMedia = [Media]()
    @Published var groupedMedia = [[Media]]()
    @Published var isLoading = true

    private var cancellable: AnyCancellable?

    init() {
        fetchAllMedia()
    }

    func fetchAllMedia() {
        MNetworking.sharedInstance.getMedia {
            print("Running")
        } completion: { data, _, _ in
            guard data != nil else { return }
            let groupedDic = Dictionary(grouping: data!) { media -> String in
                media.creationDate.toDate()!.toString(withFormat: "ddMMyyyy")
            }

            var groupedMedia = [[Media]]()
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
            }
            self.isLoading = false
        }
    }
}
