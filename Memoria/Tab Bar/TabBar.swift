//
//  TabBar.swift
//
//  Created by Sagar Patel on 2020-09-15.
//

import SwiftUI

struct TabBar: View {
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.systemBackground
    }
    
    var body: some View {
        TabView {
            NavigationView {
                Photos()
                .modifier(InlineNavBar(title: "Memoria"))
            }
            .tabItem {
                Label("Photos", systemImage: "photo.fill")
                    .accentColor(.accentColor)
            }

            NavigationView {
                Library()
                .modifier(InlineNavBar(title: "Memoria"))
            }
            .tabItem {
                Label("Library", systemImage: "books.vertical.fill")
                    .accentColor(.accentColor)
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
