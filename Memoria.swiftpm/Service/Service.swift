//
//  File.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-05-12.
//

import Alamofire
import Combine
import Foundation

class Service: SessionDelegate {
    static let shared: Service = .init()

    internal lazy var session: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 10
        return Alamofire.Session(
            configuration: configuration,
            delegate: self,
            rootQueue: DispatchQueue(label: "com.memoria.sessionManagerData.rootQueue"),
            startRequestsImmediately: true,
            interceptor: JwtInterceptor()
        )
    }()

    private init() {
        print("Starting Service Manager")
    }
}

extension Service {
    func pingServer(domain: URL) -> AnyPublisher<DataResponse<HealthCheck, NetworkError>, Never> {
        let url = Service.makeEndpoint(domain: domain, endpoint: .healthCheck)

        return AF
            .request(url, method: .get)
            .validate()
            .publishDecodable(type: HealthCheck.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func login(domain: URL, loginParameters: Login) -> AnyPublisher<DataResponse<RefreshToken, NetworkError>, Never> {
        let url = Service.makeEndpoint(domain: domain, endpoint: .apiLogin)

        return AF
            .request(url, method: .post, parameters: loginParameters, encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: RefreshToken.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchAllMedia() -> AnyPublisher<DataResponse<[Media], NetworkError>, Never> {
        let url = Service.makeEndpoint(endpoint: .media)

        return session
            .request(url, method: .get)
            .validate()
            .publishDecodable(type: [Media].self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func fetchAllAssetId() -> AnyPublisher<DataResponse<[String], NetworkError>, Never> {
        let url = Service.makeEndpoint(endpoint: .mediaAssets)

        return session
            .request(url, method: .get)
            .validate()
            .publishDecodable(type: [String].self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func uploadMedia(file: FileUpload) -> AnyPublisher<DataResponse<Data?, AFError>, Never> {
        let url = Service.makeEndpoint(endpoint: .mediaUpload)

        let multipartdata: MultipartFormData = .init()
        let parameters: [String: String] = [
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
            "source": file.source.rawValue
        ]
        for (key, value) in parameters {
            multipartdata.append(value.data(using: .utf8)!, withName: key)
        }
        if (file.url?.isFileURL) != nil {
            multipartdata.append(file.url!, withName: "files")
        }
        if (file.livePhotoUrl?.isFileURL) != nil {
            multipartdata.append(file.livePhotoUrl!, withName: "files")
        }

        return session
            .upload(multipartFormData: multipartdata, to: url, method: .post)
            .validate()
            .publishUnserialized()
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func updateMedia(media: Media) -> AnyPublisher<DataResponse<Media, NetworkError>, Never> {
        let url = Service.makeEndpoint(endpoint: .media)

        return session
            .request(url, method: .put, parameters: media)
            .validate()
            .publishDecodable(type: Media.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0) }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension Service {
    enum ENDPOINT: String {
        case staticMedia = "/data"
        case media = "/media"
        case mediaAssets = "/media/assets"
        case mediaUpload = "/media/upload"
        case apiRefresh = "/api/auth/refresh"
        case apiLogin = "/api/auth/login"
        case healthCheck = "/api/auth/health"
    }

    static func makeEndpoint(domain: URL? = nil, endpoint: ENDPOINT) -> URL {
        if domain != nil {
            return domain!.appendingPathComponent(endpoint.rawValue)
        }
        let savedURL = UserDefaults.standard.string(forKey: "serverURL") ?? "errorDomain"
        return URL(string: savedURL)!.appendingPathComponent(endpoint.rawValue)
    }
}
