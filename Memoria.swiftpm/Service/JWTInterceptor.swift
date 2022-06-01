//
//  JwtInterceptor.swift
//  
//
//  Created by Sagar R Patel on 2022-05-12.
//

import Foundation
import Alamofire

struct JwtInterceptor: RequestInterceptor {
    let keychain = MKeychain()

    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let serverUrl = UserDefaults.standard.string(forKey: "serverURL") ?? ""
        guard urlRequest.url?.absoluteString.hasPrefix(serverUrl) == true else { return completion(.success(urlRequest)) }

        var urlRequest = urlRequest
        let token = keychain.getBearerToken() ?? ""
        urlRequest.headers.add(.authorization(bearerToken: token))

        completion(.success(urlRequest))
    }

    func retry(_ request: Alamofire.Request, for _: Alamofire.Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            // The request did not fail due to a 401 Unauthorized response.
            // Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }

        print("JWT Token: Retried")
        refreshToken { isSuccess in
            isSuccess ? completion(.retry) : completion(.doNotRetry)
        }
    }

    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let refToken = keychain.getRefreshToken() else {
            completion(false)
            return
        }
        let parameters = ["refresh_token": refToken]
        let serverUrl = Service.makeEndpoint(endpoint: .apiRefresh)

        AF.request(serverUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: RefreshToken.self) { response in
                switch response.result {
                case .success:
                    keychain.setBearerToken(token: response.value?.data.payload.token ?? "")
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
    }
}
