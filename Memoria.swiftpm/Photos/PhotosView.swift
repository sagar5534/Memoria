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
    
    init() {
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
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                switch tabSelected {
                case 0:
                    NavigationView {
                        ScrollGrid
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
                default:
                    NavigationView {
                        ScrollGrid
                    }
                }
                
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        Spacer()
                        Button(action: {
                            tabSelected = 0
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 14)
                        }
                        Spacer()
                        Button(action: {
                            tabSelected = 1
                        }) {
                            Image(systemName: "square.stack")
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 14)
                        }
                        Spacer()
                        Button(action: {
                            tabSelected = 2
                        }) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 14)
                        }
                        Spacer()
                    }
                    .foregroundColor(.primary)
                }
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
        ScrollView {
            Divider()
            
            PhotoGrid(namespace: namespace, groupedMedia: photoGridData.groupedMedia, details: $details, media: $media)
                .navigationTitle("Memoria")
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
                                    autoUploadService.initiateAutoUpload()
                                }, label: {
                                    Image(systemName: "checkmark.icloud")
                                })
                                    .foregroundColor(.primary)
                            }
                            
                            NavigationLink(destination: Settings()) {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
        }
    }
}
