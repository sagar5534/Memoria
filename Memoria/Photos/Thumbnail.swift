//
//  Thumbnail.swift
//  Sagar Patel
//
//
import SwiftUI

struct Thumbnail: View {
    let item: Media

    var body: some View {
        let path = item.path.replacingOccurrences(of: "\\", with: #"/"#)
        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)

        ZStack(alignment: .bottomLeading) {
            AsyncImageCustom(url: url!,
                             placeholder: { Color(UIColor.secondarySystemBackground) },
                             image: {
                                 Image(uiImage: $0)
                                     .resizable()
                             })
                .scaledToFill()
                .frame(width: 300, height: 300, alignment: .center)
                .clipped()

            if item.isFavorite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 16, height: 16, alignment: .center)
                    .padding()
            }
        }
        .frame(width: 300, height: 300, alignment: .center)
    }
}
