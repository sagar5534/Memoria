//
//  Test2.swift
//  Test2
//
//  Created by Sagar on 2021-09-10.
//

import SwiftUI

struct Test2: View {
    @Namespace var animation
    @ObservedObject var photoGridData = PhotoGridData()
    let columns =
        [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
        ]
    @State private var media: Media?
    @State private var details = false

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    if photoGridData.allMedia.first != nil {
                        ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                            Section(header: titleHeader(with: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                                ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in

                                    ZStack {
                                        Color.red

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
                                                .aspectRatio(contentMode: .fill)
                                                .layoutPriority(-1)
                                        }
                                    }
                                    .clipped()
                                    .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: animation, isSource: true)
                                    .zIndex(media == photoGridData.groupedMedia[i][index] ? 1000 : 1)
                                    .aspectRatio(1, contentMode: .fit)
                                    .id(photoGridData.groupedMedia[i][index].id)
                                    .transition(.modal)
                                }
                            }
                            .id(UUID())
                        }
                    }
                    Spacer()
                }
            }

            if details {
                ZStack {
                    GeometryReader { geo in

                        Thumbnail(item: media!)
                            .matchedGeometryEffect(id: media!.id, in: animation)
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    if details {
                                        //                                  media = nil
                                        details.toggle()
                                    }
                                }
                            }
                    }
                }
                .transition(.invisible)
            }

        }.animation(.spring(response: 0.3, dampingFraction: 0.6), value: details)
    }
}



// if media?.id != photoGridData.groupedMedia[i][index].id {
//    GeometryReader { gr in
//
//    Thumbnail(item: photoGridData.groupedMedia[i][index])
//        .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: animation)
//        .scaledToFill()
//        .frame(height: gr.size.width)
//        .position(x: gr.frame(in: .local).midX, y: gr.frame(in: .local).midY)
//        .onTapGesture {
//            DispatchQueue.main.async {
//                if !details {
//                    media = photoGridData.groupedMedia[i][index]
//                    details.toggle()
//                }
//            }
//        }
//    }
//    .clipped()
//    .aspectRatio(1, contentMode: .fit)
//    .transition(.modal) // Ive flipped it for zindex
//
//
// } else {
//    Color.clear
//        .frame(height: 450)
// }
