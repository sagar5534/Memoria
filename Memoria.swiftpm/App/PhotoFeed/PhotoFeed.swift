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
    @EnvironmentObject var homeModel: HomeModel
    @EnvironmentObject var modalSettings: ModalSettings
    @Binding var scrollToTop: Bool

    @State private var scaler = 3
    @State private var isSquareAspect = true

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: scaler)

        ScrollView {
            AutoUploadProgress()
            if homeModel.isLoading || homeModel.groupedMedia.isEmpty {
                EmptyPageViews
            } else {
                ScrollViewReader { proxy in
                    EmptyView().id(0)
                    LazyVGrid(columns: columns, spacing: 2, pinnedViews: .sectionHeaders) {
                        ForEach(homeModel.groupedMedia, id: \.self) { group in
                            Section(header: titleHeader(header: group.first?.modificationDate.toDate()?.toString() ?? "")) {
                                ForEach(group, id: \.self) { eachMedia in
                                    feedThumbnailIcon(
                                        namespace: namespace,
                                        media: eachMedia,
                                        isChosenMedia: modalSettings.selectedItem != nil && modalSettings.selectedItem!.id == eachMedia.id,
                                        isSquareAspect: isSquareAspect
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                            modalSettings.selectedItem = eachMedia
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: scrollToTop) { target in
                        guard target else { return }
                        scrollToTop.toggle()
                        withAnimation {
                            proxy.scrollTo(0, anchor: .top)
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) { ToolbarView }
                }
            }
        }
        .onAppear {
            autoUploadService.initiateAutoUpload {
                withAnimation {
                    homeModel.fetchAllMedia()
                }
            }
        }
    }

    @ViewBuilder
    var EmptyPageViews: some View {
        if homeModel.isLoading {
            ProgressView().foregroundColor(.primary)
        } else if homeModel.groupedMedia.isEmpty {
            VStack(alignment: .center) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(.secondary)
                    .padding()

                Text("Looks Empty Here")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Text("Begin uploading your photos")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    var ToolbarView: some View {
        HStack(alignment: .center, spacing: 12.0) {
            // ICloud Button
            Button(action: {
                autoUploadService.initiateAutoUpload {
                    withAnimation {
                        homeModel.fetchAllMedia()
                    }
                }
            }, label: {
                Image(systemName: "checkmark.icloud")
            })
            .foregroundColor(.primary)

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
                    if media.mediaType == .video {
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
            .background(Color.myBackground)
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
