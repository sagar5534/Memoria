//
//  ModalView.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SDWebImageSwiftUI
// import Combine
import SwiftUI

struct ModalView: View {
    @Environment(\.modalTransitionPercent) var pct: CGFloat

    let item: Media
    var onCloseTap: () -> Void
//    var thumbnailGeometry: GeometryProxy

    var body: some View {
        let thumbPath = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let thumbUrl = URL(string: #"http://192.168.100.107:3000/data/\#(thumbPath)"#)

        let FullPath = item.path.replacingOccurrences(of: "\\", with: #"/"#)
        let FullUrl = URL(string: #"http://192.168.100.107:3000/data/\#(FullPath)"#)

        GeometryReader { geometry in

            let imgH = geometry.size.height
            let imgW = geometry.size.width

            // Size difference between the modal's image and the thumbnail
//            let d = CGSize(width: imgW - thumbnailGeometry.size.width, height: imgH - thumbnailGeometry.size.height)
            // Interpolate values from thumbnail size, to full modal size, using the pct value from the flight transition
//            let w = thumbnailGeometry.size.width + d.width * pct
//            let h = thumbnailGeometry.size.height + d.height * pct

            // Size difference between the modal's image and the thumbnail
            let d = CGSize(width: imgW - 300, height: imgH - 300)
            // Interpolate values from thumbnail size, to full modal size, using the pct value from the flight transition
            let w = 300 + d.width * pct
            let h = 300 + d.height * pct

            Color.clear.overlay(
                WebImage(url: FullUrl!)
                    .placeholder(content: {
                        // Testing
                        WebImage(url: thumbUrl!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: w, height: h, alignment: .center)
                            .clipped()
                            .onTapGesture(perform: onCloseTap)
                            .id(item.id)
                    })
                    .resizable()
                    .scaledToFit()
                    .frame(width: w, height: h, alignment: .center)
                    .clipped()
//                    .zIndex(2)
                    .onTapGesture(perform: onCloseTap)
                    .id(item.id)
            )
        }
    }
}
