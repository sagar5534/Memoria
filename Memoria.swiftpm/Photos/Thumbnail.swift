//
//  Thumbnail.swift
//  HeroAnimations
//
//

import AVFoundation
import AVKit
import CachedAsyncImage
import SwiftUI

enum mediaState {
    case thumb
    case full
    case live
}

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}

struct Thumbnail: View {
    @Environment(\.colorScheme) var colorScheme
    let item: Media
    let server = MCommConstants.makeRequestURL(endpoint: .staticMedia)

    var body: some View {
        let path = (item.thumbnailPath != "" ? item.thumbnailPath! : item.path).replacingOccurrences(of: "\\", with: #"/"#)
        let serverURL = URL(string: #"\#(server)/\#(path)"#)

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
    @State private var state: mediaState = .thumb
    @State private var liveURL: URL?
    @State private var temp = false
    private let server = MCommConstants.makeRequestURL(endpoint: .staticMedia)

    var body: some View {
        let thumbnailPath = (item.thumbnailPath ?? item.path).replacingOccurrences(of: "\\", with: #"/"#)
        let thumbnailURL = URL(string: #"\#(server)/\#(thumbnailPath)"#)!
        let fullPath = item.path.replacingOccurrences(of: "\\", with: #"/"#)
        let fullURL = URL(string: #"\#(server)/\#(fullPath)"#)!

        ZStack {
            CachedAsyncImage(
                url: thumbnailURL,
                urlCache: .imageCache
            ) { image in
                image.resizable()
            } placeholder: { Color.blue }

            switch state {
            case .full:
                CachedAsyncImage(
                    url: fullURL,
                    urlCache: .imageCache
                ) { image in
                    image.resizable()
                } placeholder: {
                    Color.clear
                }
                .transition(.opacity)

            case .live:
                AVPlayerView(videoURL: .constant(liveURL!), temp: $temp)
                    .onDisappear {
                        temp = false
                    }
            default:
                Color.clear
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                state = .full
            }
        }
        .modifier(PressActions(onPress: {
            guard state != .live, item.isLivePhoto else { return }
            let live = item.livePhotoPath!.replacingOccurrences(of: "\\", with: #"/"#)
            liveURL = URL(string: #"\#(server)/\#(live)"#)!
            withAnimation {
                temp = true
                state = .live
            }
        }, onRelease: {
            temp = false
            state = .full
        }))
    }
}

struct PressActions: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    @GestureState private var isPressingDown: Bool = false
    @GestureState private var isTapped = false

    func body(content: Content) -> some View {
        let longPress = LongPressGesture(minimumDuration: 0.5)
            .onEnded { _ in
                onPress()
            }
        let hold = DragGesture(minimumDistance: 0)
            .onEnded { _ in
                onRelease()
            }
        let sequenceGesture = longPress.sequenced(before: hold)

        content
            .gesture(sequenceGesture)
    }
}

struct AVPlayerView: UIViewControllerRepresentable {
    @Binding var videoURL: URL
    @Binding var temp: Bool

    private var player: AVPlayer {
        return AVPlayer(url: videoURL)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context _: Context) {
        if temp {
            playerController.player?.play()
            print("Live Started")
        } else {
            playerController.player?.pause()
            playerController.player?.seek(to: CMTime.zero)
            print("Live Ended")
        }
    }

    func makeUIViewController(context _: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
        playerController.requiresLinearPlayback = true
        playerController.updatesNowPlayingInfoCenter = false
        playerController.videoGravity = .resizeAspect
        playerController.view.backgroundColor = UIColor.clear
        playerController.player?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerController.player?.currentItem, queue: .main) { _ in
            playerController.player?.seek(to: CMTime.zero)
            playerController.player?.play()
        }

        return playerController
    }
}

struct Thumbnail_Previews: PreviewProvider {
    static var previews: some View {
        let media = Media(id: "", path: "Photos\\IMG_2791.jpg", source: Source.local, livePhotoPath: "Photos\\IMG_2791.mov", thumbnailPath: ".thumbs\\Photos\\IMG_2791_thumbs.jpg", isLivePhoto: true, duration: 0, modificationDate: Date().toString(), creationDate: Date().toString(), mediaSubType: 0, mediaType: 0, assetID: "", filename: "", user: "", v: 1)

        Thumbnail(item: media)
    }
}
