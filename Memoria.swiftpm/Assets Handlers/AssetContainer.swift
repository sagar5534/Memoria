//
//  SwiftUIView.swift
//
//
//  Created by Sagar R Patel on 2022-05-03.
//

import CachedAsyncImage
import SwiftUI

private enum mediaState {
    case thumb
    case full
    case live
    case video
}

struct FullResImage: View {
    let item: Media
    @State private var state: mediaState = .thumb
    @State private var liveURL: URL?
    @EnvironmentObject var playerVM: VideoPlayerModel
    @EnvironmentObject var heroSettings: ModalSettings

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
                VideoPlayer(playerVM: playerVM)
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
        .onChange(of: heroSettings.autoPlayLivePhoto) { shouldPlay in
            guard item.isLivePhoto else { return }
            shouldPlay ?
                withAnimation {
                    state = .live
                } :
                withAnimation {
                    state = .full
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if item.mediaType == .photo {
                    state = .full
                    if item.isLivePhoto {
                        playerVM.setCurrentItem(item.livePhotoPath!.toStaticURL())
                    }
                    if heroSettings.autoPlayLivePhoto {
                        withAnimation {
                            state = .live
                        }
                    }
                } else {
                    playerVM.setCurrentItem(item.path.toStaticURL())
                    state = .video
                }
            }
        }
        .onDisappear {
            playerVM.player.replaceCurrentItem(with: nil)
        }
        .if(item.isLivePhoto && !heroSettings.autoPlayLivePhoto) { view in
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
