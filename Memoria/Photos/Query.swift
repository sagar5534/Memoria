//
//  Start_VModel.swift
//  Memoria
//
//  Created by Sagar on 2021-04-23.
//

import Alamofire
import Foundation
import UIKit

class NetworkManager: ObservableObject {
    @Published var data: MediaCollection = []

    static let sharedInstance = NetworkManager()

    deinit {
        print("Destroying Start")
    }

    init() {
        print("Calling init")
        getListOfPhotos()
    }

    func getListOfPhotos() {
        AF.request("http://192.168.100.107:3000/media")
            .validate()
            .responseDecodable(of: MediaCollection.self) { response in
                guard let data = response.value else { return }
                self.data = data
            }
    }

    func upload(file: FileUpload, completionHandler: @escaping () -> Void) {
        let parameters: [String: String] = [
            "user": "610cc064a35f2243803ab48c",
            "creationDate": String(file.creationDate.timeIntervalSince1970),
            "assetId": String(file.assetId),
            "isFavorite": String(file.isFavorite),
        ]

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }
            multipartFormData.append(file.url, withName: "file", fileName: file.filename, mimeType: file.mimeType)
        }, to: "http://192.168.100.107:3000/media/upload")
            .uploadProgress { _ in
//                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { _ in
//                print(data)
                completionHandler()
            }
    }
}
