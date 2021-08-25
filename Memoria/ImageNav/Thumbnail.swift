//
//  Thumbnail.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SwiftUI
import SDWebImageSwiftUI

/// This view shows a picture, that may be zoomed and cropped (insetted)
struct Thumbnail: View {
    
    let item: String
    
    var body: some View {
        
//        let path = (item.thumbnailPath.isEmpty ? item.path : item.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
//        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)
        
        return Color.clear.overlay(
            Image(item)
//            WebImage(url: url!)
//                .placeholder(content: { ProgressView() })
                .resizable()
                .scaledToFill()
//                .frame(width: w, height: h, alignment: .center)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
                .clipped()
        )
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
    }
}
