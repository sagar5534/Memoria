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
    var downloadRequest: [String: DownloadRequest] = [:]
    var uploadRequest: [String: UploadRequest] = [:]
    var uploadMetadataInBackground: [String: FileUpload] = [:]

    public let sessionMaximumConnectionsPerHost = 5

    init() {
        print("Starting Network Service")
    }

    // MARK: - Upload

    func upload(uploadList: [FileUpload], completion: @escaping (_ success: Int, _ failed: Int) -> Void) {
        let uploadQueue = DispatchQueue.global(qos: .userInitiated)
        let uploadGroup = DispatchGroup()
        let uploadSemaphore = DispatchSemaphore(value: 1)
        var success = 0
        var failed = 0

        uploadQueue.async(group: uploadGroup) { [weak self] in
            guard let self = self else { return }

            for file in uploadList {
                uploadGroup.enter()
                uploadSemaphore.wait()

                self.uploadFile(file: file) {
                    print("Upload Started:", file.filename)
                } completion: { _, errorCode, _ in
                    if errorCode != nil {
//                        print("Upload Failed:", file, errorCode, errorDesc)
                        failed += 1
                    } else {
//                        print("Upload Success:", file)
                        success += 1
                    }
                    uploadGroup.leave()
                    uploadSemaphore.signal()
                }
            }
        }

        uploadGroup.notify(queue: .main) {
            completion(success, failed)
        }
    }

    private func uploadFile(file: FileUpload, start: @escaping () -> Void, completion: @escaping (_ file: String, _ errorCode: Int?, _ errorDescription: String?) -> Void) {
        let serverUrl = Constants.makeRequestURL(endpoint: .mediaUpload)
        let fileName = file.filename
        var uploadTask: URLSessionTask?

        MComm.shared.upload(file: file, serverUrl: serverUrl) { UploadRequest in
            self.uploadRequest[fileName] = UploadRequest
        } taskHandler: { URLSessionTask in
            uploadTask = URLSessionTask
            start()
        } progressHandler: { _ in
            // Notification Center
        } completionHandler: { _, _, errorCode, errorDescription in
            self.uploadRequest[fileName] = nil
            completion(fileName, errorCode, errorDescription)
        }
    }

    func downloadSavedAssets(start: @escaping () -> Void, completion: @escaping (_ result: AssetCollection?, _ errorCode: Int?, _ errorDescription: String?) -> Void) {
        let serverUrl = Constants.makeRequestURL(endpoint: .mediaAssets)
        var downloadTask: URLSessionTask?

        MComm.shared.downloadSavedAssets(serverUrl: serverUrl) { _ in
            // Track download task here?
        } taskHandler: { URLSessionTask in
            downloadTask = URLSessionTask
            start()
        } completionHandler: { data, _, errorCode, errorDescription in
            guard data != nil else {
                completion(nil, errorCode, errorDescription)
                return
            }
            completion(data, errorCode, errorDescription)
        }
    }

    func getMedia(start: @escaping () -> Void, completion: @escaping (_ result: MediaCollection?, _ errorCode: Int?, _ errorDescription: String?) -> Void) {
        let serverUrl = Constants.makeRequestURL(endpoint: .media)
        var downloadTask: URLSessionTask?

        MComm.shared.getMedia(serverUrl: serverUrl) { _ in
            // Track download task here?
        } taskHandler: { URLSessionTask in
            downloadTask = URLSessionTask
            start()
        } completionHandler: { data, _, errorCode, errorDescription in
            guard data != nil else {
                completion(nil, errorCode, errorDescription)
                return
            }
            completion(data, errorCode, errorDescription)
        }
    }
    
    func updateMedia(media: Media, start: @escaping () -> Void, completion: @escaping (_ result: Media?, _ errorCode: Int?, _ errorDescription: String?) -> Void) {
        let serverUrl = Constants.makeRequestURL(endpoint: .media) + "/" + media.id
        var downloadTask: URLSessionTask?
        print(serverUrl)
        MComm.shared.updateMedia(media: media, serverUrl: serverUrl) { _ in
            // Track download task here?
        } taskHandler: { URLSessionTask in
            downloadTask = URLSessionTask
            start()
        } completionHandler: { data, _, errorCode, errorDescription in
            guard data != nil else {
                completion(nil, errorCode, errorDescription)
                return
            }
            completion(data, errorCode, errorDescription)
        }
    }
    
}
