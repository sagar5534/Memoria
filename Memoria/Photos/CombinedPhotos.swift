//
//  Tester.swift
//  Memoria
//
//  Created by Sagar on 2021-08-23.
//

import Combine
import SwiftUI

class CurrentlySelected: ObservableObject {
    @Published var media: Media? = nil
}

struct CombinedPhotos: View {
    @Namespace private var nspace
    @StateObject var currentlySelected = CurrentlySelected()

    @State var thumbnailGeometry: GeometryProxy? = nil
    @State private var showShareSheet = false

    var body: some View {
        ZStack {
            // --------------------------------------------------------
            // NavigationView with LazyVGrid
            // --------------------------------------------------------
            TabView {
                NavigationView {
                    PhotoGrid(onThumbnailTap: tapThumbnail)
                        .modifier(InlineNavBar(title: "Memoria"))
                        .environmentObject(currentlySelected)
                }
                .tabItem {
                    Label("Photos", systemImage: "photo.fill")
                        .accentColor(.accentColor)
                }

//                NavigationView {
//                    Library()
//                        .modifier(InlineNavBar(title: "Memoria"))
//                }
//                .tabItem {
//                    Label("Library", systemImage: "books.vertical.fill")
//                        .accentColor(.accentColor)
//                }
            }
            .zIndex(1)

            if currentlySelected.media != nil {
                // --------------------------------------------------------
                // Backdrop to blur the grid while the modal is displayed
                // --------------------------------------------------------
                Color(UIColor.systemBackground)
                    .zIndex(2)
                    .transition(.opacity)
                    .ignoresSafeArea(.all)

                // --------------------------------------------------------
                // Modal view
                // --------------------------------------------------------
                ModalView(item: currentlySelected.media!, onCloseTap: tapBackdrop, thumbnailGeometry: thumbnailGeometry!)
                    .matchedGeometryEffect(id: currentlySelected.media!.id, in: nspace)
                    .zIndex(3)
                    .transition(.modal)
                    .ignoresSafeArea(.all)

                // --------------------------------------------------------
                // Button View
                // --------------------------------------------------------
                PhotosToolbar(onCloseTap: tapBackdrop, showShareSheet: $showShareSheet)
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(activityItems: ["Hello World"])
                    }
                    .zIndex(4)
                    .transition(.opacity)
            }
        }
    }

    func tapBackdrop() {
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                currentlySelected.media = nil
            }
        }
    }

    func tapThumbnail(_ item: Media, _ geometry: GeometryProxy) {
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                self.thumbnailGeometry = geometry
                currentlySelected.media = item
            }
        }
    }
}

struct CombinedPhotos_Preview: PreviewProvider {
    static var previews: some View {
        CombinedPhotos()
    }
}
