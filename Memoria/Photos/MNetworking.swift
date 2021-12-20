//
//  Query.swift
//  Memoria
//
//  Created by Sagar on 2021-04-23.
//

import Alamofire
import Foundation
import UIKit

class MNetworking: ObservableObject {
    static let sharedInstance = MNetworking()

    var lastReachability: Bool = true
    var networkReachability: NCCommunicationCommon.typeReachability?
    var downloadRequest: [String: DownloadRequest] = [:]
    var uploadRequest: [String: UploadRequest] = [:]
    var uploadMetadataInBackground: [String: FileUpload] = [:]
    public let sessionMaximumConnectionsPerHost = 5

    init() {
        print("Starting Network Service")
    }

    // MARK: - Upload

    func upload(uploadList: [FileUpload], start: @escaping () -> Void, completion: @escaping (_ errorCode: Int?, _ errorDescription: String?) -> Void) {
        for file in uploadList {
            // TODO: Handle background tasks here?
            // TODO: Fix completion and start to be for group. Not each file
            uploadFile(file: file, start: { start() }, completion: completion)
        }
    }

    private func uploadFile(file: FileUpload, start: @escaping () -> Void, completion: @escaping (_ errorCode: Int?, _ errorDescription: String?) -> Void) {
        let serverUrl = "http://192.168.100.35:8080/media/uploads"
        let fileName = file.filename
        var uploadTask: URLSessionTask?

        NCCommunication.sharedInstance.upload(file: file, serverUrl: serverUrl) { UploadRequest in
            self.uploadRequest[fileName] = UploadRequest
        } taskHandler: { URLSessionTask in
            uploadTask = URLSessionTask
            start()
        } progressHandler: { _ in
            // Notification Center
        } completionHandler: { _, _, errorCode, errorDescription in
            self.uploadRequest[fileName] = nil
            print(errorCode, errorDescription)
//            self.uploadComplete(fileName: metadata.filename, serverUrl: serverUrl, task: uploadTask!, errorCode: errorCode, errorDescription: errorDescription)
            completion(errorCode, errorDescription)
        }
    }
}
