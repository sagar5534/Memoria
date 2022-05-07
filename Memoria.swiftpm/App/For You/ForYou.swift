//
//  SwiftUIView.swift
//
//
//  Created by Sagar R Patel on 2022-05-02.
//

import SwiftUI

struct ForYou: View {
    let namespace: Namespace.ID
    @EnvironmentObject var photoGridData: PhotoFeedData
    @EnvironmentObject var modalSettings: ModalSettings

    @State private var scaler = 2
    @State private var selection = "Most Recent Photos"
    let colors = ["Most Recent Photos", "Album Title"]

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: scaler)

        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                HStack(alignment: .center) {
                    Text("Albums")
                        .font(.custom("OpenSans-Bold", size: 22))
                        .foregroundColor(.primary)
                    Spacer()

                    Label {
                        Picker("Sorting", selection: $selection, content: { // <2>
                            ForEach(colors, id: \.self) {
                                Text($0)
                            }
                        })
                    } icon: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(photoGridData.albumMedia.keys), id: \.self) { key in
                        thumbnailIcon(
                            namespace: namespace,
                            key: String(key),
                            media: photoGridData.albumMedia[key]!.first!,
                            albumName: String(key),
                            count: photoGridData.albumMedia[key]!.count,
                            isChosenMedia: !modalSettings.selectedAlbum.isEmpty && modalSettings.selectedAlbum == String(key)
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                guard modalSettings.selectedAlbum.isEmpty else {
                                    return
                                }
                                
                                modalSettings.selectedAlbum = String(key)
                            }
                        }
                        .id(UUID())
                    }

                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Create Album
                    Button {} label: {
                        Label("New Album", systemImage: "plus")
                    }
                }
            }
        }
    }
}

private struct thumbnailIcon: View {
    let namespace: Namespace.ID
    let key: String
    let media: Media
    let albumName: String
    let count: Int
    @State var isChosenMedia: Bool

    var body: some View {
        VStack {
            if !isChosenMedia {
                Color.clear
                    .overlay(
                        Thumbnail(media: media)
                            .aspectRatio(nil, contentMode: .fill)
                            .contentShape(Circle())
                    )
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(16)
                    .matchedGeometryEffect(id: key, in: namespace)

            } else {
                Color.clear
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
            }

            Group {
                Text(albumName)
                    .lineLimit(1)

                Text("\(count) Items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
