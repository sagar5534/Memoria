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

        AsyncImageCustom(
            url: url!,
            placeholder: { blurBackdrop },
            image: {
                Image(uiImage: $0)
                    .resizable()
                    .renderingMode(.original)
            }
        )
    }
    
    @ViewBuilder
    var blurBackdrop: some View {
        //TODO light mode
        VisualEffectView(uiVisualEffect: UIBlurEffect(style: .dark))
    }
}
