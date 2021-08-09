//
//  TabBar.swift
//
//  Created by Sagar Patel on 2020-09-15.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            NavigationView {
                Photos()
            }
            .tabItem {
                Label("Photos", systemImage: "photo.fill")
            }

            NavigationView {
                Library()
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
            .previewDevice("iPhone 11")
            .preferredColorScheme(.light)
    }
}
