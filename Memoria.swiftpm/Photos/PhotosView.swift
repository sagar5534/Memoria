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
        navBarAppearance.titleTextAttributes = attributes
        navBarAppearance.largeTitleTextAttributes = largeAttributes
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = attributes
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
//                let tabAppearance = UITabBarAppearance()
//                tabAppearance.configureWithOpaqueBackground()
//                UITabBar.appearance().standardAppearance = tabAppearance
//                UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                switch tabSelected {
                case 0:
                    NavigationView {
                        ScrollGrid
                    }
                case 1:
                    NavigationView {
                        Text("For You")
                    }
                default:
                    NavigationView {
                        ScrollGrid
                    }
                }
                                
                HStack {
                    Spacer()
                    Button(action: {
                        tabSelected = 0
                    }) {
                        Image(systemName: "photo.fill.on.rectangle.fill")
                    }
                    Spacer()
                    Button(action: {
                        tabSelected = 1
                    }) {
                        Image(systemName: "rectangle.stack.person.crop.fill")
                    }
                    Spacer()
                }
                .frame(height: UITabBarController().tabBar.frame.size.height)
                .background(.white)
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
                        HStack(alignment: .center, spacing: 14.0) {
                            Button(action: {}, label: {
                                if autoUploadService.running {
                                    Label("Backup", systemImage: "arrow.clockwise.icloud")
                                } else {
                                    Label("Backup", systemImage: "checkmark.icloud")
                                        .onTapGesture {
                                            autoUploadService.initiateAutoUpload()
                                        }
                                }
                            })
                            .foregroundColor(.primary)
                            
                            NavigationLink(destination: Settings()) {
                                Label("Settings", systemImage: "gearshape")
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
        }
    }
}
