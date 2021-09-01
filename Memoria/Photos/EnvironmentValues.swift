//
//  EnvironmentValues.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SwiftUI

extension EnvironmentValues {
    var modalTransitionPercent: CGFloat {
        get { return self[ModalTransitionKey.self] }
        set { self[ModalTransitionKey.self] = newValue }
    }

    var currentlySelectedMedia: Media? {
        get { self[currentlySelectedMediaKey.self] }
        set { self[currentlySelectedMediaKey.self] = newValue }
    }
}

public struct ModalTransitionKey: EnvironmentKey {
    public static let defaultValue: CGFloat = 0
}

public struct currentlySelectedMediaKey: EnvironmentKey {
    public static var defaultValue: Media? = nil
}
