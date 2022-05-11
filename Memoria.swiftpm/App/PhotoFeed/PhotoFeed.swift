//
//  SwiftUIView.swift
//
//
//  Created by Sagar R Patel on 2022-04-05.
//

import SwiftUI

struct PhotoFeed: View {
    let namespace: Namespace.ID
    @EnvironmentObject var autoUploadService: AutoUploadService
    @EnvironmentObject var photoGridData: PhotoFeedData
    @EnvironmentObject var modalSettings: ModalSettings
    @Binding var scrollToTop: Bool

    @State private var scaler = 3
    @State private var isSquareAspect = true
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: scaler)

        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach($photoGridData.groupedMedia, id: \.self) { $group in
                            Section(header: titleHeader(header: group.first?.modificationDate.toDate()?.toString() ?? "")) {
                                ForEach($group, id: \.self) { $media in
                                    feedThumbnailIcon(
                                        namespace: namespace,
                                        media: media,
                                        isChosenMedia: modalSettings.selectedItem != nil && modalSettings.selectedItem!.id == media.id,
                                        isSquareAspect: isSquareAspect
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                            modalSettings.selectedItem = media
                                        }
                                    }
                                }
                            }
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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(alignment: .center, spacing: 12.0) {
                        // ICloud Button
                        if autoUploadService.running {
                            Button(action: {}, label: {
                                Image(systemName: "arrow.clockwise.icloud")
                            })
                            .foregroundColor(.primary)
                        } else {
                            Button(action: {
                                autoUploadService.initiateAutoUpload {
                                    photoGridData.fetchAllMedia()
                                }
                            }, label: {
                                Image(systemName: "checkmark.icloud")
                            })
                            .foregroundColor(.primary)
                        }

                        // Menu Popup
                        Menu {
                            Button { zoomIn() } label: {
                                Label("Zoom In", systemImage: "plus.magnifyingglass")
                            }
                            .disabled(scaler <= 1)

                            Button { zoomOut() } label: {
                                Label("Zoom Out", systemImage: "plus.magnifyingglass")
                            }
                            .disabled(scaler >= 7)

                            Button {
                                withAnimation {
                                    isSquareAspect.toggle()
                                }
                            } label: {
                                Label("Aspect", systemImage: "aspectratio")
                            }

                        } label: {
                            Label("Menu", systemImage: "ellipsis.circle")
                                .labelStyle(.iconOnly)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }

    private func zoomOut() {
        withAnimation {
            scaler = scaler + 2
        }
    }

    private func zoomIn() {
        withAnimation {
            scaler = scaler - 2
        }
    }
}

struct feedThumbnailIcon: View {
    let namespace: Namespace.ID
    @State var media: Media
    @State var isChosenMedia: Bool
    @State var isSquareAspect: Bool = true

    var body: some View {
        if !isChosenMedia {
            Color.clear
                .overlay(
                    Thumbnail(media: media)
                        .aspectRatio(nil, contentMode: isSquareAspect ? .fill : .fit)
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
            .padding(.top, 8)
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
