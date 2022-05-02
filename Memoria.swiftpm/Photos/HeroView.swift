//
//  PhotoView.swift
//  PhotoView
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

class HeroSettings: ObservableObject {
    @Published var autoPlayLivePhoto = false
}

struct HeroView: View {
    @Namespace var namespace

    @ObservedObject var photoGridData = PhotoFeedData()
    @ObservedObject var autoUploadService = AutoUploadService()
    @StateObject private var playerVM = VideoPlayerModel()
    @StateObject private var heroSettings = HeroSettings()

    @State private var tabSelected = 0
    @State private var selectedItem: Media? = nil
    @State private var scrollToTop: Bool = false
    @State private var showShareSheet = false
    @State private var showModalToolbar = true
    @State private var modalOffset = CGSize.zero
    @State private var modalScale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var selectedItemFrame = CGRect()

    var body: some View {
        let toggleToolbarGesture = TapGesture()
            .onEnded { _ in
                withAnimation {
                    self.showModalToolbar.toggle()
                }
            }
        let dragGesture = DragGesture()
            .onChanged { gesture in
//                if gesture.translation.width < 0 {
//                    // left
//                }
//                if gesture.translation.width > 0 {
//                    // right
//                }
//                if gesture.translation.height < 0 {
//                    // up
//                }
                if gesture.translation.height >= 0 && modalScale == 1 {
                    // down
                    self.modalOffset.height = gesture.translation.height
                }
            }
            .onEnded { _ in
                if self.modalOffset.height > 100 {
                    closeModal()
                } else {
                    self.modalOffset = .zero
                }
            }
        let zoomGesture = MagnificationGesture()
            .onChanged { val in
                let delta = val / self.lastScale
                self.lastScale = val
                let newScale = self.modalScale * delta
                withAnimation {
                    modalScale = clamp(newScale, 1, 3)
                }
            }.onEnded { _ in
                self.lastScale = 1
            }

        let doubleTapGesture = TapGesture(count: 2)
            .onEnded { _ in
                if modalScale != 1 {
                    modalScale = 1
                } else { // quick zoom
                    let widthDirection = UIScreen.main.bounds.size.width / selectedItemFrame.width
                    let heightDirection = UIScreen.main.bounds.size.height / selectedItemFrame.height
                    let expandDirection = heightDirection >= widthDirection ? heightDirection : widthDirection
                    modalScale = expandDirection > 1.2 ? expandDirection : 2
                }
            }

        // --------------------------------------------------------
        // NavigationView with LazyVGrid
        // --------------------------------------------------------
        VStack(spacing: 0) {
            switch tabSelected {
            case 0:
                NavigationView {
                    PhotoFeed(
                        namespace: namespace,
                        photoGridData: photoGridData,
                        selectedItem: $selectedItem,
                        scrollToTop: $scrollToTop
                    )
                    .environmentObject(autoUploadService)
                    .fontedNavigationBar()
                    .navigationTitle("Memoria")
                }
                .navigationViewStyle(.stack)
            case 1:
                NavigationView {
                    Text("For You")
                        .defaultNavigationBar()
                        .navigationTitle("For You")
                }
            case 2:
                NavigationView {
                    Text("Search")
                        .defaultNavigationBar()
                        .navigationTitle("Search")
                }
            case 3:
                NavigationView {
                    Settings()
                        .defaultNavigationBar()
                        .navigationTitle("Settings")
                }
            default:
                EmptyView()
            }

            Divider()

            CustomTabBar(tabSelected: $tabSelected, scrollToTop: $scrollToTop)
        }
        .overlay(self.selectedItem != nil ?
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                FullResImage(item: self.selectedItem!)
                    .matchedGeometryEffect(id: self.selectedItem!.id, in: namespace)
                    .scaledToFit()
                    .clipped()
                    .background(GeometryGetter(rect: $selectedItemFrame))
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    .scaleEffect(modalScale)
                    .frame(
                        width: selectedItemFrame.width,
                        height: selectedItemFrame.height
                    )
                    .offset(x: modalOffset.width, y: modalOffset.height)
                    .animation(.linear(duration: 0.1), value: modalScale)
                    .animation(.linear(duration: 0.1), value: modalOffset)
                    .simultaneousGesture(zoomGesture)
            }
            .toggleScrollViewBounce()
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .simultaneousGesture(doubleTapGesture
                .exclusively(before: toggleToolbarGesture)
            )
            .overlay(showModalToolbar ?
                ModalToolbar(onCloseTap: closeModal, media: $selectedItem, showShareSheet: $showShareSheet)
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [])
                }
                : nil
            )
            .simultaneousGesture(dragGesture)
            .environmentObject(playerVM)
            .environmentObject(heroSettings)
            :
            nil
        )
    }

    private func closeModal() {
        modalScale = 1
        modalOffset = .zero
        showModalToolbar = true
        withAnimation(.spring(response: 0.20, dampingFraction: 0.8)) { self.selectedItem = nil }
    }

    // Constrains a value between the limits
    private func clamp(_ value: CGFloat, _ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        min(maxValue, max(minValue, value))
    }
}

struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { g -> Color in
            DispatchQueue.main.async { // avoids warning: 'Modifying state during view update.' Doesn't look very reliable, but works.
                self.rect = g.frame(in: .global)
            }
            return Color.clear
        }
    }
}
