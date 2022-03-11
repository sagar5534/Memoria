//
//  SettingsWebView.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-01-03.
//

import SwiftUI
import WebKit

struct SettingsWebView: View {
    let url: URL

    var body: some View {
        WKWebViewUI(request: URLRequest(url: url))
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WKWebViewUI: UIViewRepresentable {
    let request: URLRequest

    func makeUIView(context _: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        uiView.load(request)
    }
}

struct SettingsWebView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsWebView(url: URL(string: "https://google.ca")!)
    }
}
