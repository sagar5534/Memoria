//
//  PhotosView.swift
//  PhotosView
//
//  Created by Sagar on 2021-09-10.
//

import SwiftUI

struct PhotosView: View {
    @Namespace private var PhotoView
    @ObservedObject var photoGridData = PhotoGridData()
    @State private var media: Media?
    @State private var details = false

    let columns = [GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2), GridItem(.flexible(), spacing: 2)]

    var body: some View {
        ZStack {
            // 1st
            TabView {
                ScrollView {
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        photoGridData.fetchAllMedia()
                    }
                    Text("Memoria")
                        .font(.title)
                    grid
                }
                .coordinateSpace(name: "pullToRefresh")
                .tabItem {
                    Label("Photos", systemImage: "photo.on.rectangle.angled")
                }
            }
            .accentColor(.blue)

            // 2nd
            fullscreen

        }.animation(.spring(response: 0.3, dampingFraction: 0.6), value: details)
    }

    @ViewBuilder
    var grid: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                Section(header: titleHeader(with: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                    ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                        ZStack {
                            Color.clear

                            if media?.id != photoGridData.groupedMedia[i][index].id {
                                Thumbnail(item: photoGridData.groupedMedia[i][index])
                                    .onTapGesture {
                                        DispatchQueue.main.async {
                                            if !details {
                                                media = photoGridData.groupedMedia[i][index]
                                                details.toggle()
                                            }
                                        }
                                    }
                                    .scaledToFill()
                                    .layoutPriority(-1)
                            }

                            if photoGridData.groupedMedia[i][index].isFavorite && !details {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .frame(width: 16, height: 16, alignment: .center)
                                            .foregroundColor(.white)
                                            .padding()
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .clipped()
                        .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: PhotoView, isSource: true)
                        .zIndex(media == photoGridData.groupedMedia[i][index] ? 1000 : 1)
                        .aspectRatio(1, contentMode: .fit)
                        .id(photoGridData.groupedMedia[i][index].id)
                        .transition(.modal)
                    }
                }
                .id(UUID())
            }
        }
    }

    @ViewBuilder
    var fullscreen: some View {
        if details {
            ZStack {
                GeometryReader { geo in

                    Thumbnail(item: media!)
                        .matchedGeometryEffect(id: media!.id, in: PhotoView)
                        .scaledToFit()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                if details {
                                    // media = nil
                                    details.toggle()
                                }
                            }
                        }
                }
            }
            .transition(.invisible)
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
