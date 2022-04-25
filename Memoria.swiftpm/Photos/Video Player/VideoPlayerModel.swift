import AVFoundation
import Combine
import SwiftUI

final class VideoPlayerModel: ObservableObject {
    let player = AVPlayer()
    @Published var isPlaying = false
    @Published var isEditingCurrentTime = false
    @Published var currentTime: Double = .zero
    @Published var duration: Double?

    private var subscriptions: Set<AnyCancellable> = []
    private var timeObserver: Any?

    deinit {
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    init() {
        $isEditingCurrentTime
            .dropFirst()
            .filter { $0 == false }
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.player.seek(to: CMTime(seconds: self.currentTime, preferredTimescale: 1), toleranceBefore: .zero, toleranceAfter: .zero)
                if self.player.rate != 0 {
                    self.player.play()
                }
            })
            .store(in: &subscriptions)

        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                switch status {
                case .playing:
                    self?.isPlaying = true
                case .paused:
                    self?.isPlaying = false
                case .waitingToPlayAtSpecifiedRate:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)

        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: 600), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if self.isEditingCurrentTime == false {
                withAnimation(.linear) {
                    self.currentTime = time.seconds
                }
            }
        }

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
    }

    func setCurrentItem(_ item: URL) {
        let avItem = AVPlayerItem(url: item)
        currentTime = .zero
        duration = nil
        player.replaceCurrentItem(with: avItem)

        avItem.publisher(for: \.status)
            .filter { $0 == .readyToPlay }
            .sink(receiveValue: { [weak self] _ in
                self?.duration = avItem.asset.duration.seconds
            })
            .store(in: &subscriptions)
    }
}
