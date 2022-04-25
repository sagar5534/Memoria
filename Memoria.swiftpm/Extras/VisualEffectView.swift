//
//  VisualEffectView.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SwiftUI

/// A view used to blur the grid, using a UIViewRepresentable of UIKit's UIVisualEffect
private struct VisualEffectView: UIViewRepresentable {
    var uiVisualEffect: UIVisualEffect?

    func makeUIView(context _: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: UIViewRepresentableContext<Self>) {
        uiView.effect = uiVisualEffect
    }
}


struct BlurBackdrop: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        switch colorScheme {
        case .dark:
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: .systemMaterialDark))
        default:
            VisualEffectView(uiVisualEffect: UIBlurEffect(style: .systemMaterialLight))
        }
    }
}
