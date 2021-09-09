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
        case library
        case livePhoto
    }

    @State var selectedFolder: NavigationItem? = .photos

    var sidebar: some View {
        List {
            NavigationLink(destination: CombinedPhotos(), tag: NavigationItem.photos, selection: $selectedFolder) {
                Label("Photos", systemImage: "photo.on.rectangle")
            }

            NavigationLink(destination: Text(""), tag: NavigationItem.library, selection: $selectedFolder) {
                Label("Library", systemImage: "person.2.square.stack")
            }

            Section {
                NavigationLink(destination: Text(""), tag: NavigationItem.livePhoto, selection: $selectedFolder) {
                    Label("Live Photos", systemImage: "livephoto")
                }
            } header: {
                Text("Media Types")
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
//
//        NavigationView{
        SidebarNavigation()
//        }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
