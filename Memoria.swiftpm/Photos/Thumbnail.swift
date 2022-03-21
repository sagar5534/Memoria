//
//  Thumbnail.swift
//  HeroAnimations
//
//

import SwiftUI
import CachedAsyncImage

struct Thumbnail: View {
    @Environment(\.colorScheme) var colorScheme
    
    let item: Media
    
    var body: some View {
        let server = Constants.makeRequestURL(endpoint: .staticMedia)
        let path = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let serverURL = URL(string: #"\#(server)\#(path)"#)!
        
        ZStack(alignment: .bottomLeading) {
            
            CachedAsyncImage(
                url: serverURL,
                transaction: Transaction(animation: .easeOut(duration: 0.1))
            ) { phase in
                switch phase {
                case .empty:
                    blurBackdrop
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    Image(systemName: "wifi.slash")
                @unknown default:
                    blurBackdrop
                }
            }
            
            //            AsyncImageCustom(
            //                url: path,
            //                placeholder: { blurBackdrop },
            //                image: {
            //                    Image(uiImage: $0)
            //                        .resizable()
            //                        .renderingMode(.original)
            //                }
            //            )
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
