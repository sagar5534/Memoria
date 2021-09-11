//
//  Thumbnail.swift
//  HeroAnimations
//
//

import SwiftUI

struct Thumbnail: View {
    let item: Media

    var body: some View {
        let path = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)
        
        ZStack(alignment: .bottomLeading) {
            AsyncImageCustom(url: url!,
                             placeholder: { Color(UIColor.clear) },
                             image: {
                                 Image(uiImage: $0)
                                     .resizable()
                                     .renderingMode(.original)
                             })
//                .frame(width: 110, height: 110, alignment: .center)
//                .scaledToFill()
//                .clipped()

            if item.isFavorite {
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 16, height: 16, alignment: .center)
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
