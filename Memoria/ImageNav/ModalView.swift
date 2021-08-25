//
//  ModalView.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import Combine
import SwiftUI

/// A view used as a modal. It reacts to the environment key .modalTransitionPercent,
/// in order to determine how much flight it has done. This allows it to morph
/// from the thumbnail picture into its full display.
struct ModalView: View {
    // .modalTransitionPercent goes from 0 to 1 when flying in, and from 1 to 0 when flying out.
    @Environment(\.modalTransitionPercent) var pct: CGFloat
    @Environment(\.heroConfig) var config: HeroConfiguration
    
    let item: String
    var onCloseTap: () -> Void
    var thumbnail_geometry: GeometryProxy
    
    var body: some View {
            
        GeometryReader { geometry in

            let imgH = geometry.size.height
            let imgW = geometry.size.width
            
            // Size difference between the modal's image and the thumbnail
            let d = CGSize(width: imgW - thumbnail_geometry.size.width, height: imgH - thumbnail_geometry.size.height)

            // Interpolate values from thumbnail size, to full modal size, using the pct value from the flight transition
            let w = thumbnail_geometry.size.width + d.width * pct
            let h = thumbnail_geometry.size.height + d.height * pct
        
            Color.clear.overlay(
                Image(item)
                    .resizable()
                    .scaledToFit()
                    .frame(width: w, height: h, alignment: .center)
                    .clipped()
                    .zIndex(2)
                    .onTapGesture(perform: onCloseTap)
                    .id(item)
            )
//            .shadow(radius: 8 * pct)
        }
    }
}
