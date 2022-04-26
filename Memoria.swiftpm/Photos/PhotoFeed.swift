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
    @Binding var scrollToTop: Bool
    @State private var scaler: CGFloat = 120
    let openModal: (Media) -> Void
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: scaler), spacing: 2)]
        
        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                            Section(header: titleHeader(header: photoGridData.groupedMedia[i].first!.modificationDate.toDate()!.toString())
                            ) {
                                ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                                    ZStack {
                                        Color.clear
                                        if selectedItem?.id != photoGridData.groupedMedia[i][index].id {
                                            Thumbnail(media: photoGridData.groupedMedia[i][index])
                                                .scaledToFill()
                                                .layoutPriority(-1)
                                                .contentShape(Circle())
                                                .onTapGesture {
                                                    openModal(photoGridData.groupedMedia[i][index])
                                                }
                                        }
                                    }
                                    .clipped()
                                    .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: namespace)
                                    .zIndex(selectedItem?.id == photoGridData.groupedMedia[i][index].id ? 5 : 1)
                                    .aspectRatio(1, contentMode: .fit)
                                    .id(photoGridData.groupedMedia[i][index].id)
                                    .overlay(alignment: .topTrailing) {
                                        if photoGridData.groupedMedia[i][index].mediaType == 1 {
                                            VideoOverlay(duration: photoGridData.groupedMedia[i][index].duration?.secondsToString(style: .positional) ?? "")
                                        } else if photoGridData.groupedMedia[i][index].isFavorite == true {
                                            FavoriteOverlay()
                                        }
                                    }
                                }
                            }
                            .id(i)
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
