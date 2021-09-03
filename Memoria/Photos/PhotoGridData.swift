//
//  PhotoListData.swift
//  Memoria
//
//  Created by Sagar on 2021-08-31.
//

import Foundation
import Combine

class PhotoGridData: ObservableObject {
    @Published var allMedia = [Media]()
    @Published var groupedMedia = [[Media]]()

    let url = URL(string: "http://192.168.100.107:3000/media")!
    private var cancellable: AnyCancellable?
    
    init() {
        fetchAllMedia()
    }
    
    func fetchAllMedia() {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { $0.data }
            .decode(type: [Media].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.allMedia) }
            .sink { [weak self] data in
                let groupedDic = Dictionary(grouping: data) { (media) -> String in
                    return media.creationDate.toDate()!.toString(withFormat: "ddMMyyyy")
                }
                
                var groupedMedia = [[Media]]()
                let keys = groupedDic.keys.sorted { first, second in
                    return first.toDate(withFormat: "ddMMyyyy")!.timeIntervalSince1970 > second.toDate(withFormat: "ddMMyyyy")!.timeIntervalSince1970
                }
                keys.forEach { key in
                    groupedMedia.append(groupedDic[key]!)
                }

                if (self?.groupedMedia == groupedMedia) {
                    print("No refresh needed")
                }else {
                    self?.allMedia = data
                    self?.groupedMedia = groupedMedia
                }
        }
    }
}
