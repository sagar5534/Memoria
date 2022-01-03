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

        ZStack(alignment: .bottomLeading) {
            AsyncImageCustom(
                url: path,
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
