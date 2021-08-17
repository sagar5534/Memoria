import Kingfisher
import SwiftUI
import UIKit

public struct NetworkImage: SwiftUI.View {
    @State private var image: UIImage? = nil

    public let imageURL: URL?
    public let placeholderImage: UIImage
    public let animation: Animation = .easeIn

    public var body: some SwiftUI.View {
        if image != nil {
            Image(uiImage: image!)
                .resizable()
//                .transition(.opacity)
                .id(imageURL)
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
                .clipped()
        } else {
            ProgressView()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
                .onAppear(perform: loadImage)
        }
    }

    private func loadImage() {
        guard let imageURL = imageURL, image == nil else { return }
        KingfisherManager.shared.retrieveImage(with: imageURL) { result in
            switch result {
            case let .success(imageResult):
//                withAnimation(self.animation) {
                self.image = imageResult.image
//                }
            case .failure:
                break
            }
        }
    }
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        NetworkImage(imageURL: URL(string: "https://www.apple.com/favicon.ico")!,
                     placeholderImage: UIImage(systemName: "bookmark")!)
    }
}
