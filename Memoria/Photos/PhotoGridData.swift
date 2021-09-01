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
            .sink { [weak self] in
                self?.allMedia.append(contentsOf: $0)
        }
    }
}
