//
//  ContentView.swift
//  Hero Animation
//
//  Created by Kavsoft on 29/05/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @Namespace var animation
    
    let data = [
        "https://images.unsplash.com/photo-1629048153574-e46f1b3d5b67?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80",
        "https://images.unsplash.com/photo-1578763918454-d0deb5469071?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1051&q=80",
        "https://images.unsplash.com/photo-1512188066-4f19f566a388?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1489&q=80",
    ]
    let columns =
        [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
        ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(data, id: \.self) { i in
//                ZStack(alignment: .center) {
//                    Color.red
                ////
//                    ZStack(alignment: .bottomLeading) {
//                        AsyncImageCustom(url: URL(string: i)!,
//                                         placeholder: { Color(UIColor.clear) },
//                                         image: {
//                                             Image(uiImage: $0)
//                                                 .resizable()
//                                         })
//                    }
//                    .scaledToFill()
                    
                ZStack {
                    Color.red
                    
                    ZStack(alignment: .bottomLeading) {
                        AsyncImageCustom(url: URL(string: i)!,
                                         placeholder: { Color(UIColor.clear) },
                                         image: {
                                             Image(uiImage: $0)
                                                 .resizable()
                                         })
                    }
                    .aspectRatio(contentMode: .fill)
                    .layoutPriority(-1)
                }
                .clipped()
                .aspectRatio(1, contentMode: .fit)
                    
//                }
//                .frame(height: 150)
            }
        }
        
//        ZStack(alignment: .center) {
//            Color.red
//
//            let url = URL(string: "https://images.unsplash.com/photo-1629048153574-e46f1b3d5b67?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80")
//            ZStack(alignment: .bottomLeading) {
//                AsyncImageCustom(url: url!,
//                                 placeholder: { Color(UIColor.clear) },
//                                 image: {
//                                     Image(uiImage: $0)
//                                         .resizable()
//                                 })
//            }
//            .scaledToFill()
//        }
//        .frame(height: 200)
//        .clipped()
    }
}
