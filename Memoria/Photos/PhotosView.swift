//
//  PhotosView.swift
//  PhotosView
//
//  Created by Sagar on 2021-09-10.
//

import SwiftUI

struct PhotosView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let showTabbar: Bool
    @Namespace private var namespace
    @State private var media: Media?
    @State private var details = false
    @ObservedObject var photoGridData = PhotoGridData()
    @ObservedObject var autoUploadService = AutoUploadService.sharedInstance

    var body: some View {
        ZStack {
            if showTabbar {
                TabView {
                    ScrollGrid
                        .tabItem {
                            Label("Photos", systemImage: "photo.fill.on.rectangle.fill")
                        }

                    Text("For You")
                        .tabItem {
                            Label("For You", systemImage: "rectangle.stack.person.crop.fill")
                        }
                }
            } else {
                ScrollGrid
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
            HStack(alignment: .center) {
                Text("Memoria")
                    .font(.custom("Pacifico-Regular", size: 26, relativeTo: .title2))
                Spacer()

                HStack(alignment: .center, spacing: 18.0) {
                    Button(action: {}, label: {
                        if autoUploadService.running {
                            Image(systemName: "arrow.clockwise.icloud")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                        } else {
                            Image(systemName: "checkmark.icloud")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 18)
                                .onTapGesture {
                                    autoUploadService.initiateAutoUpload()
                                }
                        }
                    })
                    .foregroundColor(.primary)

                    Button(action: {}, label: {
                        Image(systemName: "gearshape")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    })
                    .foregroundColor(.primary)
                }
            }
            .padding([.horizontal, .top])

            Divider()
                .offset(x: 0, y: -20)

            PhotoGrid(namespace: namespace, groupedMedia: photoGridData.groupedMedia, details: $details, media: $media)
                .offset(x: 0, y: -20)
        }
    }
}
