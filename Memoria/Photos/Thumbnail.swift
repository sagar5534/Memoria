//
//  Thumbnail.swift
//  HeroAnimations
//
//

import SwiftUI

struct Thumbnail: View {
    @Environment(\.colorScheme) var colorScheme

    let item: Media

    var body: some View {
        let path = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let url = URL(string: #"http://192.168.100.35:12480/data/\#(path)"#)

        ZStack(alignment: .bottomLeading) {
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
    }

    @ViewBuilder
    var blurBackdrop: some View {
        switch colorScheme {
        case .dark:
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: .systemMaterialDark))
        default:
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: .systemMaterialLight))
        }
    }
}
