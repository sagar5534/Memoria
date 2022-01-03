//
//  OBModel.swift
//  Memoria
//
//  Created by Sagar R Patel on 2021-12-29.
//

import Combine
import Foundation

class OBStore: ObservableObject {
    @Published var showSignIn: Bool = false
    @Published var isError: Bool = false
    @Published var running: Bool = false

    private var workingURL: String = ""
    var cancellable: AnyCancellable?

    func pingServer(url: String) {
        let endpoint = url + (url.hasSuffix("/") ? "api/auth/health" : "/api/auth/health")
        guard let serverURL = URL(string: endpoint) else {
            isError = true
            return
        }
        var request = URLRequest(url: serverURL)
        request.httpMethod = "GET"
        running = true

        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: HealthCheck.self, decoder: JSONDecoder())
            .replaceError(with: HealthCheck(status: "unhealthy"))
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                if item.status != nil, item.status == "healthy" {
                    self?.workingURL = url
                    self?.showSignIn = true
                    self?.isError = false
                } else {
                    self?.isError = true
                    self?.showSignIn = false
                }
                self?.running = false
            }
    }

    func attempLogin(username: String, password: String) {
        let endpoint = workingURL + Constants.ENDPOINT.apiLogin.rawValue
        guard let url = URL(string: endpoint) else { return }
        let json: [String: Any] = ["username": username, "password": password]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        } catch {
            print(error.localizedDescription)
            return
        }

        running = true
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: RefreshToken.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { x in
                switch x {
                case .finished:
                    self.isError = false
                default:
                    self.isError = true
                }
                self.running = false
            }, receiveValue: { refreshToken in
                guard refreshToken.data.payload.refreshToken != nil, refreshToken.data.payload.token != nil, self.workingURL != "" else {
                    self.isError = true
                    return
                }
                UserDefaults.standard.set(self.workingURL, forKey: "serverURL")
                MKeychain.shared.setBearerToken(token: refreshToken.data.payload.token!)
                MKeychain.shared.setRefreshToken(token: refreshToken.data.payload.refreshToken!)
                UserDefaults.standard.set(true, forKey: "signedIn")
            })
    }
}
