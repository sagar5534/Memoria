//
//  SidebarNavigation.swift
//  SidebarNavigation
//
//  Created by Sagar on 2021-09-03.
//

import SwiftUI

struct SidebarNavigation: View {
    enum NavigationItem {
        case photos
        case foryou
        case library
        case livephotos
    }

    @State var selectedFolder: NavigationItem? = .photos

    var sidebar: some View {
        List {
            NavigationLink(destination: PhotosView(showTabbar: false), tag: NavigationItem.photos, selection: $selectedFolder) {
                Label("Photos", systemImage: "photo.fill.on.rectangle.fill")
            }

            NavigationLink(destination: Text(""), tag: NavigationItem.foryou, selection: $selectedFolder) {
                Label("For You", systemImage: "rectangle.stack.person.crop.fill")
            }

            Section(header: Text("Media Types")) {
                NavigationLink(destination: Text(""), tag: NavigationItem.livephotos, selection: $selectedFolder) {
                    Label("Live", systemImage: "livephoto")
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Memoria")
    }

    var body: some View {
        NavigationView {
            sidebar
        }
    }
}

struct SidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SidebarNavigation()
    }
}
