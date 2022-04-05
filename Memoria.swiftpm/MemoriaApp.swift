//
//  MemoriaApp.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import class Foundation.Bundle
import SwiftUI

@main
struct MemoriaApp: App {
    init() {
        registerFont("Pacifico-Regular", fileExtension: "ttf")
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

    func registerFont(_ name: String, fileExtension: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("No font named \(name).\(fileExtension) was found in the module bundle")
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        print(error ?? "Successfully registered font: \(name)")
    }
}
