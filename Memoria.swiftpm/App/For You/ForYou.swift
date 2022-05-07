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
                    if !modalSettings.selectedAlbum {
                        thumbnailIcon()
                            .matchedGeometryEffect(id: 122, in: namespace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                    modalSettings.selectedAlbum = true
                                }
                            }
                    } else {
                        Color.clear
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    thumbnailIcon()
                    thumbnailIcon()
                    thumbnailIcon()
                    thumbnailIcon()
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
//    let namespace: Namespace.ID
//    let media: Media

    var body: some View {
        VStack {
            Color.clear
                .overlay(
                    Image("profile")
                        .resizable()
                        .aspectRatio(nil, contentMode: .fill)
                        .contentShape(Circle())
                )
                .clipped()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(16)

            Group {
                Text("Album Name")
                    .lineLimit(1)

                Text("100 Items")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
