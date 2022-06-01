//
//  PhotoView.swift
//  PhotoView
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

struct Home: View {
    @Namespace var namespace

    @StateObject var homeModel = HomeModel()
    @StateObject var autoUploadService = AutoUploadService()
    @StateObject var modalSettings = ModalSettings()

    @State private var tabSelected = 0
    @State private var scrollToTop: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tabSelected {
                case 0:
                    NavigationView {
                        PhotoFeed(
                            namespace: namespace,
                            scrollToTop: $scrollToTop
                        )
                        .environmentObject(autoUploadService)
                        .fontedNavigationBar()
                        .navigationTitle("Memoria")
                    }
                    .navigationViewStyle(.stack)
                case 1:
                    NavigationView {
                        ForYou(
                            namespace: namespace
                        )
                        .defaultNavigationBar()
                        .navigationTitle("For You")
                    }
                    .navigationViewStyle(.stack)
                case 2:
                    NavigationView {
                        Color.myBackground.overlay(Text("Search Coming Soon"))
                            .defaultNavigationBar()
                            .navigationTitle("Search")
                    }
                case 3:
                    NavigationView {
                        Settings()
                            .defaultNavigationBar()
                            .navigationTitle("Settings")
                    }
                default:
                    EmptyView()
                }
            }
            .overlay(alignment: .bottom, content: {
                if homeModel.isError {
                    ErrorMessage()
                }
            })

            Divider()

            MTabBar(tabSelected: $tabSelected, scrollToTop: $scrollToTop)
        }
        .overlay(
            AlbumView(namespace: namespace)
        )
        .overlay(
            Modal(namespace: namespace)
        )
        .environmentObject(modalSettings)
        .environmentObject(homeModel)
    }
}

private struct ErrorMessage: View {
    var body: some View {
        Label("Cannot connect to Memoria", systemImage: "wifi.exclamationmark")
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .foregroundColor(.primary)
            .colorInvert()
            .transition(.move(edge: .bottom))
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ErrorMessage()
    }
}
