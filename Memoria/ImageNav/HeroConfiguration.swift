//
//  HeroConfiguration.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SwiftUI

var sourceImagesSize = CGSize(width: 600, height: 400)

public struct HeroConfiguration {

    private var _thumbnailScalingFactor: CGFloat = sourceImagesSize.width / sourceImagesSize.height


    /// Thumbnail size
    var thumbnailSize: CGSize = CGSize(width: 150, height: 150)
    var modalSize: CGSize = CGSize(width: 350, height: 350)

    /// Aspect ratio of provided images
    var aspectRatio: CGFloat = sourceImagesSize.width / sourceImagesSize.height

    /// Zoomed factor of thumbnail images. It is kept valid by checking with lowestFactor and
    /// highestFactor. These are determine by the thumbnail size.
    var thumbnailScalingFactor: CGFloat {
        get { min(max(_thumbnailScalingFactor, lowestFactor), highestFactor) }
        set { _thumbnailScalingFactor = min(max(newValue, lowestFactor), highestFactor) }
    }

    /// A default configuration
    public static let `default` = HeroConfiguration()

    /// The default configuration for portrait layouts
    public static let defaultPortrait = HeroConfiguration(
        thumbnailSize: CGSize(width: 150, height: 150),
        thumbnailScalingFactor: 1.5,
        modalSize: CGSize(width: 350, height: 350),
        aspectRatio: sourceImagesSize.width / sourceImagesSize.height
    )

    /// Thumbnail's aspect ratio (read-only)
    var thumbnailAspectRatio: CGFloat {
        return (thumbnailSize.width / thumbnailSize.height)
    }

    /// Lowest scaling factor possible for the current thumbnail size
    var lowestFactor: CGFloat {
        return max(aspectRatio / thumbnailAspectRatio, 1)
    }

    /// Highest scaling factor possible for the current thumbnail size
    var highestFactor: CGFloat {
        return lowestFactor * 6;
    }

    init() {
        self.thumbnailScalingFactor = _thumbnailScalingFactor // make sure it is in bounds
    }

    init(thumbnailSize: CGSize, thumbnailScalingFactor: CGFloat, modalSize: CGSize, aspectRatio: CGFloat) {
        self.thumbnailSize = thumbnailSize
        self.thumbnailScalingFactor = thumbnailScalingFactor
        self.modalSize = modalSize
        self.aspectRatio = aspectRatio
    }
}

