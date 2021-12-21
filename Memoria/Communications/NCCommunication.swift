//
//  NCCommunication.swift
//  Nextcloud
//
//  Created by Marino Faggiana on 12/10/19.
//  Copyright © 2018 Marino Faggiana. All rights reserved.
//
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Alamofire
import Foundation

public class NCCommunication: SessionDelegate {
    static let sharedInstance = NCCommunication()

    internal lazy var sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return Alamofire.Session(configuration: configuration, delegate: self, rootQueue: DispatchQueue(label: "com.memoria.sessionManagerData.rootQueue"), startRequestsImmediately: true, requestQueue: nil, serializationQueue: nil, interceptor: nil, serverTrustManager: nil, redirectHandler: nil, cachedResponseHandler: nil, eventMonitors: [AlamofireLogger()])
    }()

    private let reachabilityManager = Alamofire.NetworkReachabilityManager()

    override public init(fileManager: FileManager = .default) {
        print("Starting Communication Service")

        super.init(fileManager: fileManager)
        startNetworkReachabilityObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeUser"), object: nil)
        stopNetworkReachabilityObserver()
    }

    public func isNetworkReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }

    private func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { status in
//            print("Reachability", status)
            switch status {
            case .unknown:
                NCCommunicationCommon.shared.delegate?.networkReachabilityObserver?(NCCommunicationCommon.typeReachability.unknown)

            case .notReachable:
                NCCommunicationCommon.shared.delegate?.networkReachabilityObserver?(NCCommunicationCommon.typeReachability.notReachable)

            case .reachable(.ethernetOrWiFi):
                NCCommunicationCommon.shared.delegate?.networkReachabilityObserver?(NCCommunicationCommon.typeReachability.reachableEthernetOrWiFi)

            case .reachable(.cellular):
                NCCommunicationCommon.shared.delegate?.networkReachabilityObserver?(NCCommunicationCommon.typeReachability.reachableCellular)
            }
        })
    }

    private func stopNetworkReachabilityObserver() {
        reachabilityManager?.stopListening()
    }

    func upload(file: FileUpload, serverUrl: String, queue: DispatchQueue = .main,
                requestHandler _: @escaping (_ request: UploadRequest) -> Void = { _ in },
                taskHandler: @escaping (_ task: URLSessionTask) -> Void = { _ in },
                progressHandler: @escaping (_ progress: Progress) -> Void = { _ in },
                completionHandler: @escaping (_ account: String, _ error: AFError?, _ errorCode: Int?, _ errorDescription: String?) -> Void)
    {
        guard serverUrl != "" else { return }
        //        let account = NCCommunicationCommon.shared.account

        let parameters: [String: String] = [
            // TODO: user account
            "user": "61bfc7c7c58be9e15101870b",
            "assetId": String(file.assetId),
            "filename": String(file.filename),
            "mediaType": String(file.mediaType),
            "mediaSubType": String(file.mediaSubType),
            "creationDate": String(file.creationDate.timeIntervalSince1970),
            "modificationDate": String(file.modificationDate.timeIntervalSince1970),
            "duration": String(file.duration),
            "isFavorite": file.isFavorite.description,
            "isHidden": file.isHidden.description,
            "isLivePhoto": file.isLivePhoto.description,
        ]

        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }

            if (file.url?.isFileURL) != nil {
                multipartFormData.append(file.url!, withName: "files")
            }
            if (file.livePhotoUrl?.isFileURL) != nil {
                multipartFormData.append(file.livePhotoUrl!, withName: "files")
            }

        }, to: serverUrl, method: .post)
            .validate()
            .onURLSessionTaskCreation(perform: { task in
                queue.async { taskHandler(task) }
            })
            .uploadProgress { progress in
                queue.async { progressHandler(progress) }
            }
            .response(queue: DispatchQueue.main) { response in
                switch response.result {
                case let .failure(error):
                    let resultError = NCCommunicationError().getError(error: error, httResponse: response.response)
                    queue.async { completionHandler("nil", error, resultError.errorCode, resultError.description ?? "") }
                case .success:
                    queue.async { completionHandler("nil", nil, nil, nil) }
                }
            }
    }

    func downloadSavedAssets(serverUrl: String, queue: DispatchQueue = .main,
                             requestHandler _: @escaping (_ request: UploadRequest) -> Void = { _ in },
                             taskHandler: @escaping (_ task: URLSessionTask) -> Void = { _ in },
                             completionHandler: @escaping (_ res: AssetCollection?, _ error: AFError?, _ errorCode: Int?, _ errorDescription: String?) -> Void)
    {
        guard serverUrl != "" else { return }
        // let account = NCCommunicationCommon.shared.account

        let parameters: [String: String] = [
            // TODO: user account
            "user": "61bfc7c7c58be9e15101870b",
        ]

        AF.request(serverUrl, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .onURLSessionTaskCreation(perform: { task in
                queue.async { taskHandler(task) }
            })
            .responseDecodable(of: AssetCollection.self) { response in
                switch response.result {
                case let .failure(error):
                    let resultError = NCCommunicationError().getError(error: error, httResponse: response.response)
                    queue.async { completionHandler(nil, error, resultError.errorCode, resultError.description ?? "") }
                case .success:
                    queue.async { completionHandler(response.value, nil, nil, nil) }
                }
            }
    }

    // MARK: - SessionDelegate

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if NCCommunicationCommon.shared.delegate == nil {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        } else {
            NCCommunicationCommon.shared.delegate?.authenticationChallenge?(session, didReceive: challenge, completionHandler: { authChallengeDisposition, credential in
                completionHandler(authChallengeDisposition, credential)
            })
        }
    }
}

final class AlamofireLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        if NCCommunicationCommon.shared.levelLog > 0 {
            NCCommunicationCommon.shared.writeLog("Network request started: \(request)")

            if NCCommunicationCommon.shared.levelLog > 1 {
                let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? "None"
                let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"

                NCCommunicationCommon.shared.writeLog("Network request headers: \(allHeaders)")
                NCCommunicationCommon.shared.writeLog("Network request body: \(body)")
            }
        }
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        guard let date = NCCommunicationCommon.shared.convertDate(Date(), format: "yyyy-MM-dd' 'HH:mm:ss") else { return }
        let responseResultString = String("\(response.result)")
        let responseDebugDescription = String("\(response.debugDescription)")
        let responseAllHeaderFields = String("\(String(describing: response.response?.allHeaderFields))")

        if NCCommunicationCommon.shared.levelLog > 0 {
            if NCCommunicationCommon.shared.levelLog == 1 {
                if let request = response.request {
                    let requestString = "\(request)"
                    NCCommunicationCommon.shared.writeLog("Network response request: " + requestString + ", result: " + responseResultString)
                } else {
                    NCCommunicationCommon.shared.writeLog("Network response result: " + responseResultString)
                }

            } else {
                NCCommunicationCommon.shared.writeLog("Network response result: \(date) " + responseDebugDescription)
                NCCommunicationCommon.shared.writeLog("Network response all headers: \(date) " + responseAllHeaderFields)
            }
        }
    }
}
