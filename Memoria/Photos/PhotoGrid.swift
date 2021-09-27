//
//  Photo Grid V2.swift
//  Photo Grid V2
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

struct PhotoGrid: View {
    let namespace: Namespace.ID
    let groupedMedia: [[Media]]

    @Binding var details: Bool
    @Binding var media: Media?

    @State var lastScaleValue: CGFloat = 1.0
    @State private var scaler: CGFloat = 120

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: scaler), spacing: 2)]

        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(groupedMedia.indices, id: \.self) { i in
                Section(header: titleHeader(header: groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                    ForEach(groupedMedia[i].indices, id: \.self) { index in
                        ZStack {
                            // Background
                            Color.clear

                            // Thumbnail
                            if media?.id != groupedMedia[i][index].id {
                                Thumbnail(item: groupedMedia[i][index])
                                    .onTapGesture {
                                        DispatchQueue.main.async {
                                            if !details {
                                                media = groupedMedia[i][index]
                                                details.toggle()
                                            }
                                        }
                                    }
                                    .scaledToFill()
                                    .layoutPriority(-1)
                            }

                            // Media Info
                            if groupedMedia[i][index].isFavorite && !details {
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
                        .matchedGeometryEffect(id: groupedMedia[i][index].id, in: namespace, isSource: true)
                        .zIndex(media == groupedMedia[i][index] ? 100 : 1)
                        .aspectRatio(1, contentMode: .fit)
                        .id(groupedMedia[i][index].id)
                        .transition(.invisible)
                    }
                }
                .id(UUID())
            }
        }
    }
}

struct titleHeader: View {
    let header: String

    var body: some View {
        Text(header)
            .font(.custom("OpenSans-SemiBold", size: 15))
            .foregroundColor(.primary)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PhotoGrid_Previews: PreviewProvider {
    static var previews: some View {
        titleHeader(header: "Sat, Jan 3")
    }
}
