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
                print(data)
            }
    }

    func upload() {
        let image = UIImage(named: "IMG_7")
        let imageData = image!.jpegData(compressionQuality: 1)

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "file", fileName: "fileName.jpg", mimeType: "image/jpeg")
        }, to: "http://192.168.100.107:3000/media/upload")
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                debugPrint(response)
            }
    }
}
