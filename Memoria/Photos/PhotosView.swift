//
//  PhotosView.swift
//  PhotosView
//
//  Created by Sagar on 2021-09-10.
//

import SwiftUI

struct PhotosView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Namespace private var namespace
    @State private var media: Media?
    @State private var details = false
    @ObservedObject var photoGridData = PhotoGridData()
    @ObservedObject var autoUploadService = AutoUploadService.sharedInstance
    
    var body: some View {
        ZStack {
            TabView {
                ScrollView {
                    PhotoGrid(namespace: namespace, groupedMedia: photoGridData.groupedMedia, details: $details, media: $media)
                }
                    .tabItem {
                        Label("Photos", systemImage: "photo.fill.on.rectangle.fill")
                    }
                
                Text("For You")
                    .tabItem {
                        Label("For You", systemImage: "rectangle.stack.person.crop.fill")
                    }
            }
            
            // If a photo is selected
            if details {
                PhotoDetail(namespace: namespace, details: $details, media: $media)
            }
        }
        .animation(details ? .spring(response: 0.25, dampingFraction: 0.8) :
            .spring(response: 0.2, dampingFraction: 0.8), value: details)
        .navigationTitle("Memoria")
        .navigationBarTitleDisplayMode(details ? .inline : .automatic)
//        .navigationBarColor(backgroundColor: UIColor, tintColor: <#T##UIColor#>)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: Settings()) {
                    Label("Settings", systemImage: "gearshape")
                        .foregroundColor(.primary)
                }
            }
        }
        
        .onAppear {
            if #available(iOS 15, *) {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//                appearance.background
//                appearance.backgroundColor = UIColor(red: 0.0/255.0, green: 125/255.0, blue: 0.0/255.0, alpha: 1.0)
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
            
        }
    }
}
