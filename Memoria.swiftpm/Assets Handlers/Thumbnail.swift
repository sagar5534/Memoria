import CachedAsyncImage
import SwiftUI

struct Thumbnail: View {
    @Environment(\.colorScheme) var colorScheme
    let media: Media

    var body: some View {
        let path = (media.thumbnailPath != "" ? media.thumbnailPath! : media.path)

        CachedAsyncImage(
            url: path.toStaticURL(),
            urlCache: .imageCache,
            transaction: Transaction(animation: .easeOut(duration: 0.1))
        ) { phase in
            switch phase {
            case .empty:
                BlurBackdrop()
            case let .success(image):
                image
                    .resizable()
            case .failure:
                BlurBackdrop()
            @unknown default:
                BlurBackdrop()
            }
        }
    }
}

struct Thumbnail_Previews: PreviewProvider {
    static var previews: some View {
        let media = Media(id: "", path: "Photos\\IMG_2791.jpg", source: Source.local, livePhotoPath: "Photos\\IMG_2791.mov", thumbnailPath: ".thumbs\\Photos\\IMG_2791_thumbs.jpg", isLivePhoto: true, duration: 0, modificationDate: Date().toString(), creationDate: Date().toString(), mediaSubType: 0, mediaType: 0, assetID: "", filename: "", user: "", v: 1)

        Thumbnail(media: media)
    }
}
