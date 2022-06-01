//
//  OBModel.swift
//  Memoria
//
//  Created by Sagar R Patel on 2021-12-29.
//

import Combine
import Foundation
import SwiftUI

class OBModel: ObservableObject {
    @Published var showSignIn: Bool = false
    @Published var isError: Bool = false
    @Published var running: Bool = false

    private var workingURL: URL?
    private var cancellableSet: Set<AnyCancellable> = []
    private var service: Service = Service.shared

    func pingServer(url: String) {
        running = true
        guard let testDomain = URL(string: url) else { return }

        service.pingServer(domain: testDomain)
            .sink { dataResponse in
                self.running = false

                if dataResponse.value?.status == .Healthy {
                    self.workingURL = testDomain
                    self.isError = false
                    self.showSignIn = true
                } else {
                    self.isError = true
                    self.showSignIn = false
                }
            }
            .store(in: &cancellableSet)
    }

    func attempLogin(username: String, password: String) {
        guard let domain = workingURL else { return }
        let login = Login(username: username, password: password)
        running = true

        service.login(domain: domain, loginParameters: login)
            .sink { dataResponse in
                self.running = false
                guard dataResponse.error == nil else {
                    self.isError = true
                    return
                }

                let refreshToken = dataResponse.value
                guard refreshToken?.data.payload.refreshToken != nil, refreshToken?.data.payload.token != nil else {
                    self.isError = true
                    self.running = false
                    return
                }
                UserDefaults.standard.set(self.workingURL?.absoluteString, forKey: "serverURL")
                MKeychain.shared.setBearerToken(token: refreshToken!.data.payload.token!)
                MKeychain.shared.setRefreshToken(token: refreshToken!.data.payload.refreshToken!)
                UserDefaults.standard.set(true, forKey: "signedIn")
            }
            .store(in: &cancellableSet)
    }
}
