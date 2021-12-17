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
        print("Calling init")
    }
    
    //MARK: - Upload
    func upload(metadata: FileUpload, start: @escaping () -> Void, completion: @escaping (_ errorCode: Int?, _ errorDescription: String?)->())  {
        
        let metadata = metadata
        
        //TODO Handle background tasks here?
        uploadFile(metadata: metadata, start: { start() }, completion: completion)
    }
    
    
    private func uploadFile(metadata: FileUpload, start: @escaping () -> Void, completion: @escaping (_ errorCode: Int?, _ errorDescription: String?)->()) {
        
        let serverUrl = "http://192.168.100.35:3000/upload"
        let fileName = metadata.filename
        var uploadTask: URLSessionTask?
        
        
        NCCommunication.sharedInstance.upload(file: metadata, serverUrl: serverUrl) { (UploadRequest) in
            self.uploadRequest[fileName] = UploadRequest
        } taskHandler: { (URLSessionTask) in
            uploadTask = URLSessionTask
            start()
        } progressHandler: { (Progress) in
            //Notification Center
        } completionHandler: { (account, error, errorCode, errorDescription) in
            self.uploadRequest[fileName] = nil
//            self.uploadComplete(fileName: metadata.filename, serverUrl: serverUrl, task: uploadTask!, errorCode: errorCode, errorDescription: errorDescription)
            completion(errorCode, errorDescription)
        }

    }
    
}
