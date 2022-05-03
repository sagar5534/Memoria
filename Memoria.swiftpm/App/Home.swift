//
//  PhotoView.swift
//  PhotoView
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

struct Home: View {
    @Namespace var namespace

    @ObservedObject var photoGridData = PhotoFeedData()
    @ObservedObject var autoUploadService = AutoUploadService()

    @State private var tabSelected = 0
    @State private var selectedItem: Media? = nil
    @State private var scrollToTop: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch tabSelected {
                case 0:
                    NavigationView {
                        PhotoFeed(
                            namespace: namespace,
                            photoGridData: photoGridData,
                            selectedItem: $selectedItem,
                            scrollToTop: $scrollToTop
                        )
                        .environmentObject(autoUploadService)
                        .fontedNavigationBar()
                        .navigationTitle("Memoria")
                    }
                    .navigationViewStyle(.stack)
                case 1:
                    NavigationView {
                        ForYou(photoGridData: photoGridData)
                            .defaultNavigationBar()
                            .navigationTitle("For You")
                    }
                    .navigationViewStyle(.stack)
                case 2:
                    NavigationView {
                        Text("Search")
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
                if photoGridData.isError {
                    ErrorMessage()
                }
            })

            Divider()

            MTabBar(tabSelected: $tabSelected, scrollToTop: $scrollToTop)
        }
        .overlay(
            Modal(namespace: namespace, selectedItem: $selectedItem)
        )
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
