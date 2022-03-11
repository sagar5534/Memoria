//
//  MNetworkingExtras.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-01-02.
//

import Foundation

struct Constants {
    enum ENDPOINT: String {
        case staticMedia = "/data"
        case media = "/media"
        case mediaAssets = "/media/assets"
        case mediaUpload = "/media/upload"
        case apiRefresh = "/api/auth/refresh"
        case apiLogin = "/api/auth/login"
    }

    static func makeRequestURL(endpoint: ENDPOINT) -> String {
        // TODO: maybe break or log user out?
        var temp = UserDefaults.standard.string(forKey: "serverURL") ?? ""
        guard temp != "" else {
            print("Error: serverURL does not exist")
            return ""
        }
        temp = temp + endpoint.rawValue
        return temp
    }
}
