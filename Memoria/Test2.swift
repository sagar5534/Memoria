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
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVGrid(columns: columns, spacing: 4) {
//                    ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
//                        Section(header: titleHeader(with: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
//                            ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { x in
//                                let asset = photoGridData.groupedMedia[i][x]
            ////                                if media?.id != asset.id {
//                                    Thumbnail(item: asset)
//                                        .frame(width: 110, height: 110, alignment: .center)
//                                        .scaledToFill()
//                                        .matchedGeometryEffect(id: asset.id, in: animation)
//                                        .onTapGesture {
//                                            DispatchQueue.main.async {
//                                                media = asset
//                                                details.toggle()
//                                            }
//                                        }
//                                        .id(UUID())
//                                        .background(Color.yellow)
            ////                                }
//
//                            }
            ////                            .transition(.modal)
//
//                        }
//                        .id(UUID())
//                    }
//                }
//            }
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 4) {
                    if photoGridData.allMedia.first != nil {
                        ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                            Section(header: titleHeader(with: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                                ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                                    if media?.id != photoGridData.groupedMedia[i][index].id {
                                        Thumbnail(item: photoGridData.groupedMedia[i][index])
                                            .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: animation)
//                                            .frame(width: 110, height: 110, alignment: .center)
                                            .aspectRatio(1, contentMode: .fill)
                                            .onTapGesture {
                                                DispatchQueue.main.async {
                                                    if !details {
                                                        media = photoGridData.groupedMedia[i][index]
                                                        details.toggle()
                                                    }
                                                }
                                            }
                                            .transition(.modal) // Ive flipped it for zindex

                                    } else {
                                        Color.clear
                                            .frame(width: 110, height: 110, alignment: .center)
                                    }
                                }
                            }
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
                            .clipped()
                            .onTapGesture {
                                DispatchQueue.main.async {
                                    media = nil
                                    details.toggle()
                                }
                            }
                    }
                }
                .transition(.invisible)
            }

        }.animation(.spring(), value: details)
    }
}

//
////  Test2.swift
////  Test2
////
////  Created by Sagar on 2021-09-10.
////
//
// import SwiftUI
//
// struct Test2: View {
//    @Namespace var animation
//    @ObservedObject var photoGridData = PhotoGridData()
//    let columns =
//        [
//            GridItem(.flexible(), spacing: 4),
//            GridItem(.flexible(), spacing: 4),
//            GridItem(.flexible(), spacing: 4),
//        ]
//    @State private var media: Media?
//    @State private var details = false
//
//    var body: some View {
//        ZStack {
//            ScrollView(.vertical, showsIndicators: false) {
//                LazyVGrid(columns: columns, spacing: 4) {
//                    ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
//                        Section(header: titleHeader(with: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
//                            ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { x in
//                                let asset = photoGridData.groupedMedia[i][x]
////                                if media?.id != asset.id {
//                                    Thumbnail(item: asset)
//                                        .frame(width: 110, height: 110, alignment: .center)
//                                        .scaledToFill()
//                                        .matchedGeometryEffect(id: asset.id, in: animation)
//                                        .onTapGesture {
//                                            DispatchQueue.main.async {
//                                                media = asset
//                                                details.toggle()
//                                            }
//                                        }
//                                        .id(UUID())
//                                        .background(Color.yellow)
////                                }
//
//                            }
////                            .transition(.modal)
//
//                        }
//                        .id(UUID())
//                    }
//                }
//            }
////            HStack {
////                if photoGridData.allMedia.first != nil {
////                    if !details {
////                        Thumbnail(item: photoGridData.allMedia.first!)
////                            .matchedGeometryEffect(id: "id1", in: animation)
////                            .frame(width: 110, height: 110, alignment: .center)
////                            .onTapGesture {
////                                DispatchQueue.main.async {
////                                    details.toggle()
////                                }
////                            }
////                            .transition(.modal)
////                    }
////                }
////                Spacer()
////            }
//
//            if details{
//                ZStack {
//                    Thumbnail(item: media!)
//                        .matchedGeometryEffect(id: media?.id, in: animation)
//                        .frame(width: 300, height: 300)
//                        .onTapGesture {
//                            DispatchQueue.main.async {
//                                media = nil
//                                details.toggle()
//                            }
//                        }
//                }
////                .transition(.invisible)
//            }
//
//        }.animation(.spring(), value: details)
//    }
// }
