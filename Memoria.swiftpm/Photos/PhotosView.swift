//
//  PhotosView.swift
//  PhotosView
//
//  Created by Sagar on 2021-09-10.
//

import SwiftUI

struct PhotosView: View {
    @Namespace private var namespace
    @State private var media: Media?
    @State private var details = false
    @State private var tabSelected = 0
    
    @ObservedObject var photoGridData = PhotoGridData()
    @ObservedObject var autoUploadService = AutoUploadService.sharedInstance
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch tabSelected {
                case 0:
                    NavigationView {
                        ScrollGrid
                            .navigationTitle("Memoria")
                            .onAppear { 
                                let attributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 17)!]
                                let largeAttributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 26)!]
                                let navBarAppearance = UINavigationBarAppearance()
                                navBarAppearance.configureWithOpaqueBackground()
                                navBarAppearance.titlePositionAdjustment.vertical = 1
                                navBarAppearance.titleTextAttributes = attributes
                                navBarAppearance.largeTitleTextAttributes = largeAttributes
                                navBarAppearance.backButtonAppearance.normal.titleTextAttributes = attributes
                                UINavigationBar.appearance().standardAppearance = navBarAppearance
                                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
                            }
                            .onDisappear { 
                                let navBarAppearance = UINavigationBarAppearance()
                                navBarAppearance.configureWithOpaqueBackground()
                                UINavigationBar.appearance().standardAppearance = navBarAppearance
                                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
                            }
                    }
                    .navigationViewStyle(.stack)
                case 1:
                    NavigationView {
                        Text("For You")
                    }
                case 2: 
                    NavigationView {
                        Text("Search")
                    }
                case 3: 
                    NavigationView {
                        Settings()
                    }
                default:
                    EmptyView()
                }
                
                Divider()
                HStack {
                    Spacer()
                    NavBarItem(tabSelected: $tabSelected, tag: 0, icon: "house")
                    Spacer()
                    NavBarItem(tabSelected: $tabSelected, tag: 1, icon: "square.stack")
                    Spacer()
                    NavBarItem(tabSelected: $tabSelected, tag: 2, icon: "magnifyingglass")
                    Spacer()
                    NavBarItem(tabSelected: $tabSelected, tag: 3, icon: "person.fill")
                    Spacer()
                }
                .foregroundColor(.primary)
                .frame(height: UITabBarController().tabBar.frame.size.height)
                .background(.background)
            }
            
            if details {
                PhotoDetail(namespace: namespace, details: $details, media: $media)
            }
        }
        .animation(details ? .spring(response: 0.25, dampingFraction: 0.8) :
                        .spring(response: 0.2, dampingFraction: 0.8), value: details)
    }
    
    @ViewBuilder
    var ScrollGrid: some View {
        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                Divider()
                PhotoGrid(namespace: namespace, groupedMedia: photoGridData.groupedMedia, details: $details, media: $media)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            HStack(alignment: .center, spacing: 12.0) {
                                if autoUploadService.running {
                                    Button(action: {}, label: {
                                        Image(systemName: "arrow.clockwise.icloud")
                                    })
                                        .foregroundColor(.primary)
                                } else {
                                    Button(action: {
                                        autoUploadService.initiateAutoUpload { 
                                            photoGridData.fetchAllMedia()
                                        }
                                    }, label: {
                                        Image(systemName: "checkmark.icloud")
                                    })
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
            }
        }
    }
}

private struct NavBarItem: View {
    @Binding var tabSelected: Int
    var tag: Int
    var icon: String
    
    @ViewBuilder
    var body: some View {
        Button(action: {
            tabSelected = tag
        }) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .padding(.vertical, 14)
        }
    }
}


