////
////  HeroView.swift
////  HeroAnimations
////
////  Created by SwiftUI-Lab on 04-Jul-2020.
////  https://swiftui-lab.com/matchedGeometryEffect-part1
////
//
//import SwiftUI
//import Combine
//
//struct HeroView: View {
//    @Namespace var nspace
//    @Environment(\.colorScheme) var scheme
//
//    // Hero Configuration
//    @State private var config: HeroConfiguration
//    @State private var portraitConfig: HeroConfiguration
//    @State private var landscapeConfig: HeroConfiguration
//
//    @State private var selectedItem: Media? = nil
//    @State private var blur = false
//    @State private var showConfigPanel: Bool = false
//    @State private var isPortrait: Bool?
//    @State private var scrollUp = PassthroughSubject<Void, Never>()
//
//    @State private var itemArray: [ItemData]
//
//    init(itemArray: [ItemData], portraitConfig: HeroConfiguration = .defaultPortrait, landscapeConfig: HeroConfiguration = .defaultLandscape) {
//        self._itemArray = State(initialValue: itemArray)
//        self._config = State(initialValue: .default)
//        self._landscapeConfig = State(initialValue: landscapeConfig)
//        self._portraitConfig = State(initialValue: portraitConfig)
//    }
//
//    var body: some View {
//        let columns = [GridItem(.adaptive(minimum: config.thumbnailSize.width, maximum: config.thumbnailSize.width), spacing: self.config.horizontalSeparation)]
//
//        return ZStack {
//
//            // --------------------------------------------------------
//            // NavigationView with LazyVGrid
//            // --------------------------------------------------------
//            NavigationView {
//                List {
//                    LazyVGrid(columns: columns, alignment: .center, spacing: 4) {
//                        ForEach(itemArray) { item in
//                            if item.id != self.selectedItem?.id {
//                                Thumbnail(item: item)
//                                    .onTapGesture { tapThumbnail(item) }
//                                    .matchedGeometryEffect(id: item.id, in: nspace, properties: .frame)
//                                    .transition(.invisible)
//                            } else {
//                                //Clear background for list. Needs to be sized with the grid.
//                                Color.clear.frame(width: config.thumbnailSize.width, height: config.thumbnailSize.height)
//                            }
//                        }
//                    }
//                }
//                .navigationTitle(Text("Our Food Service"))
//            }
//            .navigationViewStyle(StackNavigationViewStyle())
//            .zIndex(1)
//
//            // --------------------------------------------------------
//            // Backdrop to blur the grid while the modal is displayed
//            // --------------------------------------------------------
//            if blur {
//                VisualEffectView(uiVisualEffect: UIBlurEffect(style: config.darkMode ? .dark : .light))
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture(perform: tapBackdrop)
//                    .transition(.opacity)
//                    .zIndex(2)
//            }
//
//            // --------------------------------------------------------
//            // Modal view
//            // --------------------------------------------------------
//            if self.selectedItem != nil {
//                Color.clear.overlay(
//                    ModalView(item: self.selectedItem!, onCloseTap: tapBackdrop, scrollUp: scrollUp)
//                        .matchedGeometryEffect(id: self.selectedItem!.id, in: nspace, properties: .position)
//                )
//                .zIndex(3)
//                .transition(.modal)
//            }
//
//        }
////        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .environment(\.colorScheme, config.darkMode ? .dark : .light)
//        .environment(\.heroConfig, config)
//        .background(configSwapper())
//    }
//
//    /// When the backdrop is tapped, close the modal and unblur the screen
//    func tapBackdrop() {
//        withAnimation(.blur) { self.blur = false }
//
//        DispatchQueue.main.async {
//            withAnimation(.hero) { self.selectedItem = nil }
//            scrollUp.send()
//        }
//    }
//
//    /// Blur the screen and open a modal on top.
//    func tapThumbnail(_ item: Media) {
//        withAnimation(.hero) { self.selectedItem = item }
//
//        DispatchQueue.main.async {
//            withAnimation(.blur) { self.blur = true }
//        }
//    }
//
//    /// This view will handle having different HeroConfiguration for portrait / landscape.
//    func configSwapper() -> some View {
//        GeometryReader { geometry -> Color in
//            DispatchQueue.main.async {
//                withAnimation(.resetConfig) {
//                    if geometry.size.height > geometry.size.width {
//                        if !(self.isPortrait ?? false) {
//                            if self.isPortrait != nil { self.landscapeConfig = self.config }
//                            self.config = portraitConfig
//                            self.isPortrait = true
//                        }
//                    } else {
//                        if self.isPortrait ?? true {
//                            if self.isPortrait != nil { self.portraitConfig = self.config }
//                            self.config = landscapeConfig
//                            self.isPortrait = false
//                        }
//                    }
//                }
//            }
//
//            return .clear
//        }
//    }
//
//}
