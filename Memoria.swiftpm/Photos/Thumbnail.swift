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
        .onAppear {
            print(serverURL)
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
    @State var state: mediaState = .thumb
    @State private var liveURL: URL?
    @State private var temp = false

    var body: some View {
        let server = MCommConstants.makeRequestURL(endpoint: .staticMedia)
        
        let path = (item.thumbnailPath ?? item.path).replacingOccurrences(of: "\\", with: #"/"#)
        let serverURL = URL(string: #"\#(server)/\#(path)"#)!
        
        let full = item.path.replacingOccurrences(of: "\\", with: #"/"#)
        let fullserverURL = URL(string: #"\#(server)/\#(full)"#)!
        
        ZStack {
            CachedAsyncImage(
                url: serverURL,
                urlCache: .imageCache
            ) { image in
                image.resizable()
            } placeholder: { Color.blue }
                .transition(.opacity)
            
            switch state {
            case .full:
                CachedAsyncImage(
                    url: fullserverURL,
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        
        // Sequence Gesture
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
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        if temp {
            playerController.player?.play()
            print("Live Started")
        } else {
            playerController.player?.pause()
            playerController.player?.seek(to: CMTime.zero)
            print("Live Ended")
        }
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
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
