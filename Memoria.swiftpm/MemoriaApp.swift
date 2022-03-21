//
//  MemoriaApp.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI
import class Foundation.Bundle

#if !SPM
extension Bundle {
  static var module:Bundle { Bundle(identifier: "ca.sagarp.Memoria")! }
}
#endif


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
        guard let fontURL = Bundle.module.url(forResource: name, withExtension: fileExtension) else {
            print("No font named \(name).\(fileExtension) was found in the module bundle")
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        print(error ?? "Successfully registered font: \(name)")
    }
    
}
