//
//  Thumbnail.swift
//  HeroAnimations
//
//

import SDWebImageSwiftUI
import SwiftUI
import AlamofireImage
import Combine

struct Thumbnail: View {
    let item: Media

    var body: some View {
//        let path = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let path = (item.path).replacingOccurrences(of: "\\", with: #"/"#)

        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)
        
        AsyncImage(
            url: url!,
            placeholder: { ProgressView() },
            image: {
                Image(uiImage: $0)
                    .resizable()
            }
        )
        .scaledToFill()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
        .clipped()

        
//        WebImage(url: url!)
//            .placeholder(content: { ProgressView() })
//            .resizable()
//            .scaledToFill()
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
//            .clipped()
    }
}
