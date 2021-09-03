//
//  Thumbnail.swift
//  HeroAnimations
//
//

import AlamofireImage
import Combine
import SDWebImageSwiftUI
import SwiftUI

struct Thumbnail: View {
    let item: Media

    var body: some View {
        let path = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)

        AsyncImageCustom(
            url: url!,
            placeholder: { Color.clear },
            image: {
                Image(uiImage: $0)
                    .resizable()
            })
            .transition(.fade(duration: 0.25))
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 150, maxHeight: .infinity, alignment: .center)
            .clipped()
    }
}
