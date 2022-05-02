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
    @Binding var selectedItem: Media?
    @Binding var scrollToTop: Bool
    @State private var scaler: CGFloat = 120

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: scaler), spacing: 2)]

        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                            Section(header: titleHeader(header: photoGridData.groupedMedia[i].first!.modificationDate.toDate()!.toString())) {
                                ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                                    thumbnailIcon(
                                        namespace: namespace,
                                        media: photoGridData.groupedMedia[i][index],
                                        isChosenMedia: selectedItem != nil && selectedItem!.id == photoGridData.groupedMedia[i][index].id
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                            selectedItem = photoGridData.groupedMedia[i][index]
                                        }
                                    }
                                }
                            }
                            .id(UUID())
                        }
                    }
                    .onChange(of: scrollToTop) { target in
                        if target {
                            scrollToTop.toggle()
                            withAnimation {
                                proxy.scrollTo(0, anchor: .top)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct thumbnailIcon: View {
    let namespace: Namespace.ID
    let media: Media
    @State var isChosenMedia: Bool

    var body: some View {
        if !isChosenMedia {
            Color.clear
                .overlay(
                    Thumbnail(media: media)
                        .scaledToFill()
                        .layoutPriority(-1)
                        .contentShape(Circle())
                )
                .clipped()
                .aspectRatio(1, contentMode: .fit)
                .matchedGeometryEffect(id: media.id, in: namespace)
                .overlay(alignment: .topTrailing) {
                    if media.mediaType == 1 {
                        VideoOverlay(duration: media.duration?.secondsToString(style: .positional) ?? "")
                    } else if media.isFavorite == true {
                        FavoriteOverlay()
                    }
                }
        } else {
            Color.clear
                .clipped()
                .aspectRatio(1, contentMode: .fit)
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
            .font(.footnote)
            .padding(4.5)
            .foregroundColor(.white)
        }.background(Color.black.opacity(0.3))
            .cornerRadius(10.0)
            .padding(3.5)
    }
}

private struct FavoriteOverlay: View {
    var body: some View {
        ZStack {
            Image(systemName: "star.circle")
                .font(.footnote)
                .padding(4.5)
                .foregroundColor(.white)
        }.background(Color.black.opacity(0.3))
            .cornerRadius(10.0)
            .padding(3.5)
    }
}
