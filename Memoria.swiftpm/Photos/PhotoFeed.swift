//
//  SwiftUIView.swift
//
//
//  Created by Sagar R Patel on 2022-04-05.
//

import SwiftUI

struct PhotoFeed: View {
    let namespace: Namespace.ID

    @ObservedObject var photoGridData: PhotoFeedData

    @State var selectedItem: Media? = nil
    @State private var scaler: CGFloat = 120
    var openModal: (Media) -> Void

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: scaler), spacing: 2)]

        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                        Section(header: titleHeader(header: photoGridData.groupedMedia[i].first!.modificationDate.toDate()!.toString())) {
                            ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                                ZStack {
                                    Color.clear
                                    if selectedItem?.id != photoGridData.groupedMedia[i][index].id {
                                        Thumbnail(item: photoGridData.groupedMedia[i][index])
                                            .onTapGesture {
                                                openModal(photoGridData.groupedMedia[i][index])
                                            }
                                            .scaledToFill()
                                            .layoutPriority(-1)
                                    }
                                }
                                .clipped()
                                .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: namespace)
                                .zIndex(selectedItem?.id == photoGridData.groupedMedia[i][index].id ? 100 : 1)
                                .aspectRatio(1, contentMode: .fit)
                                .id(photoGridData.groupedMedia[i][index].id)
                                .overlay(alignment: .topTrailing) {
                                    if photoGridData.groupedMedia[i][index].mediaType == 1 {
                                        VideoOverlay(duration: photoGridData.groupedMedia[i][index].duration?.secondsToString(style: .positional) ?? "")
                                    }
                                }
                            }
                        }
                        .id(UUID())
                    }
                }
            }
        }
    }
}

private struct titleHeader: View {
    let header: String

    var body: some View {
        Text(header)
            .font(.custom("OpenSans-SemiBold", size: 14))
            .foregroundColor(.primary)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct VideoOverlay: View {
    let duration: String
    var body: some View {
        ZStack {
            Label(
                title: { Text(duration) },
                icon: { Image(systemName: "play.circle") }
            )
            .font(.callout)
            .padding(6)
            .foregroundColor(.white)
        }.background(Color.black.opacity(0.3))
            .cornerRadius(10.0)
            .padding(4)
    }
}

// struct Photofeed_Previews: PreviewProvider {
//    static var previews: some View {
//        let media = Media(id: "", path: "Photos\\IMG_2791.jpg", source: Source.local, livePhotoPath: "Photos\\IMG_2791.mov", thumbnailPath: ".thumbs\\Photos\\IMG_2791_thumbs.jpg", isLivePhoto: true, duration: 0, modificationDate: Date().toString(), creationDate: Date().toString(), mediaSubType: 0, mediaType: 0, assetID: "", filename: "", user: "", v: 1)
//    }
// }
