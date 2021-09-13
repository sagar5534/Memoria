////
////  Tester.swift
////  Memoria
////
////  Created by Sagar on 2021-08-23.
////
//
//import Combine
//import SwiftUI
//
//class CurrentlySelected: ObservableObject {
//    @Published var media: Media? = nil
//}
//
//struct CombinedPhotos: View {
//    @Namespace private var nspace
//    @StateObject var currentlySelected = CurrentlySelected()
//
//    @State var thumbnailGeometry: GeometryProxy? = nil
//    @State private var showShareSheet = false
//
//    @State var media: Media? = nil
//
//    var body: some View {
//        ZStack {
//            // --------------------------------------------------------
//            // NavigationView with LazyVGrid
//            // --------------------------------------------------------
//            TabView {
//                PhotoGrid(media: $media, onThumbnailTap: tapThumbnail, namespace: nspace)
//                    .environmentObject(currentlySelected)
//                    .tabItem {
//                        Label("Photos", systemImage: "photo.on.rectangle.angled")
//                    }
////                NavigationView {
////                    Library()
////                        .modifier(InlineNavBar(title: "Memoria"))
////                }
////                .tabItem {
////                    Label("Library", systemImage: "books.vertical.fill")
////                        .accentColor(.accentColor)
////                }
//            }
//            .zIndex(1)
//            .accentColor(.blue)
//
//            if media != nil {
//                // --------------------------------------------------------
//                // Backdrop to blur the grid while the modal is displayed
//                // --------------------------------------------------------
//                Color(UIColor.systemBackground)
//                    .zIndex(2)
////                    .transition(.opacity)
//                    .ignoresSafeArea(.all)
//                    .animation(.easeIn)
//
//                // --------------------------------------------------------
//                // Modal view
//                // --------------------------------------------------------
////                Thumbnail(item: media!)
////                    .frame(width: 600, height: 600, alignment: .center)
////                    .matchedGeometryEffect(id: media!.id, in: nspace)
////                    .zIndex(3)
////                    .ignoresSafeArea(.all)
////                    .animation(Animation.linear)
//
////                ModalView(item: currentlySelected.media!, onCloseTap: tapBackdrop)
////                    .matchedGeometryEffect(id: currentlySelected.media!.id, in: nspace)
////                    .zIndex(3)
//                ////                    .transition(.modal)
////                    .ignoresSafeArea(.all)
//
//                // --------------------------------------------------------
//                // Button View
//                // --------------------------------------------------------
//                PhotosToolbar(onCloseTap: tapBackdrop, showShareSheet: $showShareSheet)
//                    .sheet(isPresented: $showShareSheet) {
//                        ShareSheet(activityItems: [])
//                    }
//                    .zIndex(4)
//                    .transition(.opacity)
//            }
//        }
//    }
//
//    func tapBackdrop() {
//        DispatchQueue.main.async {
//            withAnimation(.spring()) {
//                currentlySelected.media = nil
//            }
//        }
//    }
//
//    func tapThumbnail(_ item: Media) {
//        DispatchQueue.main.async {
//            withAnimation(.spring()) {
//                currentlySelected.media = item
//            }
//        }
//    }
//}
//
//struct CombinedPhotos_Preview: PreviewProvider {
//    static var previews: some View {
//        CombinedPhotos()
//    }
//}
