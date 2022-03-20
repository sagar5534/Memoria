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
    @ObservedObject var photoGridData = PhotoGridData()
    @ObservedObject var autoUploadService = AutoUploadService.sharedInstance
    
    init() {
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 17)!]
        let largeAttributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 26)!]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = attributes
        appearance.largeTitleTextAttributes = largeAttributes
        appearance.backButtonAppearance.normal.titleTextAttributes = attributes
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack {
            TabView {
                NavigationView {
                    ScrollGrid
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Photos", systemImage: "photo.fill.on.rectangle.fill")
                }
                
                NavigationView{
                    Text("For You")
                }
                .tabItem {
                    Label("For You", systemImage: "rectangle.stack.person.crop.fill")
                }
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
