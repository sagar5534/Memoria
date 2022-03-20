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
                NavigationView {
                    ScrollGrid
                }
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
            
            //                Text("Memoria")
            //                    .font(.custom("Pacifico-Regular", size: 26, relativeTo: .title2))
            
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
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                    
                    guard let customFont = UIFont(name: "Pacifico-Regular", size: UIFont.labelFontSize) else {
                        fatalError("""
                            Failed to load the "CustomFont-Light" font.
                            Make sure the font file is included in the project and the font name is spelled correctly.
                            """
                        )
                    }
//                    label.font = UIFontMetrics.default.scaledFont(for: customFont)
//                    label.adjustsFontForContentSizeCategory = true
                    
                    let attributes = [NSAttributedString.Key.font: customFont]

                    UINavigationBar.appearance().titleTextAttributes = attributes

                }
        }
    }
}
