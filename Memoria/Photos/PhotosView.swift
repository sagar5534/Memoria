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
    @State var selected: String? = ""
    
    let columns = [GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4), GridItem(.flexible(), spacing: 4)]
    
    var body: some View {
        ZStack {
            // 1st
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    photoGridData.fetchAllMedia()
                }
                
                Text("Memoria")
                    .font(.title2)
                
                grid
            }
            .coordinateSpace(name: "pullToRefresh")
            
            // 2nd
            fullscreen
        }
    }
    
    @ViewBuilder
    var grid: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                Section(header: titleHeader(with: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                    ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { x in
                        let asset = photoGridData.groupedMedia[i][x]
                        if selected != asset.id {
                            Thumbnail(item: asset)
                                .matchedGeometryEffect(id: asset.id, in: PhotoView, properties: .size)
                                .onTapGesture {
                                    withAnimation(.interactiveSpring(response: 3, dampingFraction: 0.7, blendDuration: 0)) {
                                        selected = asset.id
                                    }
                                }
                                .id(UUID())
                        } else {
                            Color.green
                                .frame(width: 110, height: 110)
                        }
                    }
                }
                .id(UUID())
            }
        }
    }
    
    @ViewBuilder
    var fullscreen: some View {
        GeometryReader { geo in

            ForEach(photoGridData.allMedia.indices, id: \.self) { index in
                if photoGridData.allMedia[index].id == selected {
                    let item = photoGridData.allMedia[index]
                    let path = item.thumbnailPath.replacingOccurrences(of: "\\", with: #"/"#)
                    let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)
                    
                    VStack {
                        Spacer()
                        Image("Logo")
                            .resizable()
//                        AsyncImageCustom(url: url!,
//                                         placeholder: { Color(UIColor.secondarySystemBackground) },
//                                         image: {
//                                             Image(uiImage: $0)
//                                                 .resizable()
//                                         })
                            .matchedGeometryEffect(id: photoGridData.allMedia[index].id, in: PhotoView)
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                            .opacity(1)
//                        .clipped()
                            .onTapGesture {
                                selected = ""
                            }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
    }
}
