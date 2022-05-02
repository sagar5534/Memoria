import CachedAsyncImage
import SwiftUI

private enum mediaState {
    case thumb
    case full
    case live
    case video
}

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}

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

struct FullResImage: View {
    let item: Media
    @State private var state: mediaState = .thumb
    @State private var liveURL: URL?
    @EnvironmentObject var playerVM: VideoPlayerModel

    var body: some View {
        let thumbnailPath = (item.thumbnailPath ?? item.path)

        ZStack {
            CachedAsyncImage(
                url: thumbnailPath.toStaticURL(),
                urlCache: .imageCache
            ) { image in
                image.resizable()
            } placeholder: { Color.clear }

            switch state {
            case .full:
                CachedAsyncImage(
                    url: item.path.toStaticURL()
                ) { image in
                    image.resizable()
                } placeholder: {
                    Color.clear
                }
                .transition(.opacity)

            case .live, .video:
                CustomVideoPlayer(playerVM: playerVM)
                    .transition(.opacity)
                    .onAppear {
                        playerVM.player.play()
                        print("Video Started")
                    }
                    .onDisappear {
                        playerVM.player.pause()
                        print("Video Ended")
                    }
            default:
                Color.clear
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if item.mediaType == 0 {
                    state = .full
                    if item.isLivePhoto {
                        playerVM.setCurrentItem(item.livePhotoPath!.toStaticURL())
                    }
                } else {
                    playerVM.setCurrentItem(item.path.toStaticURL())
                    state = .video
                }
            }
        }
        .if(item.isLivePhoto) { view in
            view.modifier(PressActions(onPress: {
                guard state != .live, item.isLivePhoto else { return }
                withAnimation {
                    state = .live
                }
            }, onRelease: {
                withAnimation {
                    state = .full
                }
            }))
        }
    }
}

private struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    @GestureState private var isPressingDown: Bool = false
    @GestureState private var isTapped = false

    func body(content: Content) -> some View {
        let longPress = LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                onPress()
            }
        let hold = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded { _ in
                onRelease()
            }
        let sequenceGesture = longPress.sequenced(before: hold)

        content
            .onTapGesture {} // Solves scrolling in the parent for live photos. Dont ask blame Apple
            .gesture(sequenceGesture)
    }
}

struct Thumbnail_Previews: PreviewProvider {
    static var previews: some View {
        let media = Media(id: "", path: "Photos\\IMG_2791.jpg", source: Source.local, livePhotoPath: "Photos\\IMG_2791.mov", thumbnailPath: ".thumbs\\Photos\\IMG_2791_thumbs.jpg", isLivePhoto: true, duration: 0, modificationDate: Date().toString(), creationDate: Date().toString(), mediaSubType: 0, mediaType: 0, assetID: "", filename: "", user: "", v: 1)

        Thumbnail(media: media)
    }
}
