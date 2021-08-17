//
//  Details.swift
//  Memoria
//
//  Created by Om Patel on 2021-08-17.
//

import SwiftUI
import SDWebImageSwiftUI

struct Details: View {
    
    var media: Media
    
    var body: some View {
        
        let path = media.path.replacingOccurrences(of: "\\", with: #"/"#)
        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)
        
        WebImage(url: url!)
            .placeholder(content: { ProgressView() })
            .resizable()
            .scaledToFit()
        
    }
}

//struct Details_Previews: PreviewProvider {
//    static var previews: some View {
//        Details(media: <#Media#>)
//    }
//}
