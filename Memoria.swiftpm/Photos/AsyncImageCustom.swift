// import Combine
// import Foundation
// import SwiftUI
// import UIKit
//
// struct AsyncImageCustom<Placeholder: View>: View {
//    @StateObject private var loader: ImageLoader
//    private let placeholder: Placeholder
//    private let image: (UIImage) -> Image
//
//    init(
//        url: String,
//        @ViewBuilder placeholder: () -> Placeholder,
//        @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
//    ) {
//        self.placeholder = placeholder()
//        self.image = image
//        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
//    }
//
//    var body: some View {
//        content
//            .onAppear(perform: loader.load)
//    }
//
//    private var content: some View {
//        Group {
//            if loader.image != nil {
//                image(loader.image!)
//            } else {
//                placeholder
//            }
//        }
//    }
// }
//
// class ImageLoader: ObservableObject {
//    @Published var image: UIImage?
//
//    private(set) var isLoading = false
//
//    private let url: String
//    private var cache: ImageCache?
//    private var cancellable: AnyCancellable?
//
//    private static let imageProcessingQueue = DispatchQueue(label: "com.memoria.Image-processing")
//
//    init(url: String, cache: ImageCache? = nil) {
//        self.url = url
//        self.cache = cache
//    }
//
//    deinit {
//        cancel()
//    }
//
//    func load() {
//        guard !isLoading else { return }
//
//        let server = Constants.makeRequestURL(endpoint: .staticMedia)
//        let serverURL = URL(string: #"\#(server)\#(url)"#)!
//        if let image = cache?[url] {
//            self.image = image
//            return
//        }
//
//        cancellable = URLSession.shared.dataTaskPublisher(for: serverURL)
//            .map { UIImage(data: $0.data) }
//            .replaceError(with: nil)
//            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
//                          receiveOutput: { [weak self] in self?.cache($0) },
//                          receiveCompletion: { [weak self] _ in self?.onFinish() },
//                          receiveCancel: { [weak self] in self?.onFinish() })
//            .subscribe(on: Self.imageProcessingQueue)
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] img in
//                withAnimation(Animation.easeOut(duration: 0.1)) {
//                    self?.image = img
//                }
//            }
//    }
//
//    func cancel() {
//        cancellable?.cancel()
//    }
//
//    private func onStart() {
//        isLoading = true
//    }
//
//    private func onFinish() {
//        isLoading = false
//    }
//
//    private func cache(_ image: UIImage?) {
//        image.map { cache?[url] = $0 }
//    }
// }
//
// protocol ImageCache {
//    subscript(_: String) -> UIImage? { get set }
// }
//
// struct TemporaryImageCache: ImageCache {
//    private let cache = NSCache<NSString, UIImage>()
//
//    subscript(_ key: String) -> UIImage? {
//        get { cache.object(forKey: key as NSString) }
//        set { newValue == nil ? cache.removeObject(forKey: key as NSString) : cache.setObject(newValue!, forKey: key as NSString) }
//    }
// }
//
// struct ImageCacheKey: EnvironmentKey {
//    static let defaultValue: ImageCache = TemporaryImageCache()
// }
//
// extension EnvironmentValues {
//    var imageCache: ImageCache {
//        get { self[ImageCacheKey.self] }
//        set { self[ImageCacheKey.self] = newValue }
//    }
// }
