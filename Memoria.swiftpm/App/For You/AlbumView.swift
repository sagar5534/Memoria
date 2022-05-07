//
//  SwiftUIView.swift
//
//
//  Created by Sagar R Patel on 2022-05-05.
//

import SwiftUI

struct AlbumView: View {
    let namespace: Namespace.ID
    @EnvironmentObject var modalSettings: ModalSettings
    @EnvironmentObject var photoGridData: PhotoFeedData
    @State private var scaler = 2

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: scaler)

        if !modalSettings.selectedAlbum.isEmpty {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.20, dampingFraction: 0.8)) {
                            modalSettings.selectedAlbum = ""
                        }
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                    })
                    .padding()
                    .contentShape(Rectangle())

                    Spacer()

                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    })
                    .padding()
                    .contentShape(Rectangle())
                }

                ScrollView {
                    VStack(spacing: 0) {
                        Text(modalSettings.selectedAlbum)
                            .font(.title)
                            .foregroundColor(.primary)
                            .padding()
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        feedThumbnailIcon(
                            namespace: namespace,
                            media: photoGridData.albumMedia[Substring(modalSettings.selectedAlbum)]!.first!,
                            isChosenMedia: false
                        )
                        .padding(.bottom, 2)

                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(photoGridData.albumMedia[Substring(modalSettings.selectedAlbum)]!.dropFirst(), id: \.self) { media in
                                feedThumbnailIcon(
                                    namespace: namespace,
                                    media: media,
                                    isChosenMedia: modalSettings.selectedItem != nil && modalSettings.selectedItem!.id == media.id
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                        modalSettings.selectedItem = media
                                    }
                                }
                                .id(UUID())
                            }
                        }
                    }
                }
            }
            .matchedGeometryEffect(id: modalSettings.selectedAlbum, in: namespace)
            .background(Color.white)
        }
    }
}
