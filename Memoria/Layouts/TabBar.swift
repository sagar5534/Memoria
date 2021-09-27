//
//  TabBar.swift
//  TabBar
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            Text("Sagar")
                .tabItem {
                    Label("Photos", systemImage: "photo.fill.on.rectangle.fill")
                }

            Text("For You")
                .tabItem {
                    Label("For You", systemImage: "rectangle.stack.person.crop.fill")
                }

            Text("Library")
                .tabItem {
                    Label("Library", systemImage: "books.vertical.fill")
                }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
