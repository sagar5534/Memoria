//
//  Thumbnail.swift
//  HeroAnimations
//
//

import CachedAsyncImage
import SwiftUI

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}

struct Thumbnail: View {
    @Environment(\.colorScheme) var colorScheme
    let item: Media
    @State var isThumb = true

    var body: some View {
        let server = Constants.makeRequestURL(endpoint: .staticMedia)
        let path = (isThumb ? item.thumbnailPath : item.path)
            .replacingOccurrences(of: "\\", with: #"/"#)
        let serverURL = URL(string: #"\#(server)\#(path)"#)!

        CachedAsyncImage(
            url: serverURL,
            urlCache: .imageCache,
            transaction: Transaction(animation: .easeOut(duration: 0.1))
        ) { phase in
            switch phase {
            case .empty:
                blurBackdrop
            case let .success(image):
                image
                    .resizable()
            case .failure:
                Image(systemName: "wifi.slash")
            @unknown default:
                blurBackdrop
            }
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

struct FullResImage: View {
    let item: Media

    var body: some View {
        let server = Constants.makeRequestURL(endpoint: .staticMedia)
        let path = item.thumbnailPath.replacingOccurrences(of: "\\", with: #"/"#)
        let serverURL = URL(string: #"\#(server)\#(path)"#)!

        CachedAsyncImage(
            url: serverURL,
            urlCache: .imageCache
        ) { image in
            image.resizable()
        } placeholder: {}
    }
}
