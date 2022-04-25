import AVFoundation
import AVKit
import Combine
import SwiftUI
import UIKit

final class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    var player: AVPlayer? {
        get {
            playerLayer.player
        }
        set {
            playerLayer.videoGravity = .resizeAspect
            playerLayer.player = newValue
        }
    }
}

struct CustomVideoPlayer: UIViewRepresentable {
    @ObservedObject var playerVM: VideoPlayerModel

    func makeUIView(context _: Context) -> PlayerView {
        let view = PlayerView()
        view.player = playerVM.player
        return view
    }

    func updateUIView(_: PlayerView, context _: Context) {}
}
