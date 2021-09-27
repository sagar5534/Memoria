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
    @ObservedObject var photoGridData = PhotoGridData()
    @State private var media: Media?
    @State private var details = false

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

                    Text("Library")
                        .tabItem {
                            Label("Library", systemImage: "books.vertical.fill")
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

            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Text("Memoria")
                        .font(.custom("Pacifico-Regular", size: 30))
                        .foregroundColor(Color("PhotoLoading"))
                    Spacer()
                }
                UserImage()
            }
            .padding(.horizontal)

            PhotoGrid(namespace: namespace, groupedMedia: photoGridData.groupedMedia, details: $details, media: $media)
        }
    }
}
