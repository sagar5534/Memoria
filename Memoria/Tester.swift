//
//  Tester.swift
//  Memoria
//
//  Created by Sagar on 2021-08-23.
//

import Combine
import SwiftUI

struct Tester: View {
    @Namespace private var animation

    let columns = [
        //        GridItem(.fixed(150), spacing: 4),
//        GridItem(.fixed(150), spacing: 4),
//        GridItem(.fixed(150), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
    ]

    let imgs = ["IMG_1", "IMG_2", "IMG_3", "IMG_4", "IMG_5", "IMG_6"]
    @State var selectedItem: String? = nil
    @State var thumbnail_geo: GeometryProxy? = nil

    @State private var blur = false
    @State private var showShareSheet = false

    var body: some View {
        ZStack {
            // --------------------------------------------------------
            // NavigationView with LazyVGrid
            // --------------------------------------------------------
            NavigationView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 4) {
                    ForEach(imgs, id: \.self) { item in
                        if item != self.selectedItem {
                            GeometryReader { geometry in
                                Image(item)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
                                    .clipped()
                                    .onTapGesture { tapThumbnail(item, geometry) }
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)

                            .matchedGeometryEffect(id: item, in: animation)
                            .transition(.invisible)

                            
                        } else {
                            Color.clear
                        }
                    }
                }
                .modifier(InlineNavBar(title: "Memoria"))
            }
            .zIndex(1)

            // --------------------------------------------------------
            // Backdrop to blur the grid while the modal is displayed
            // --------------------------------------------------------
            if blur {
                Color.clear.overlay(
                    NavigationView {
                        Color.clear
                            .modifier(InlineNavBar(title: selectedItem ?? ""))
                            .toolbar {
                                ToolbarItemGroup(placement: .bottomBar) {
                                    Button(action: { self.showShareSheet.toggle() }, label: {
                                        Label(
                                            title: {},
                                            icon: { Image(systemName: "square.and.arrow.up") }
                                        )
                                    })
                                }
                            }
                            .sheet(isPresented: $showShareSheet) {
                                ShareSheet(activityItems: ["Hello World"])
                            }
                    }
                )
                .zIndex(2)
                .transition(.opacity)
            }

            // --------------------------------------------------------
            // Modal view
            // --------------------------------------------------------
            if self.selectedItem != nil {
                Color.clear.overlay(
                        ModalView(item: selectedItem!, onCloseTap: tapBackdrop, thumbnail_geometry: thumbnail_geo!)
                            .matchedGeometryEffect(id: self.selectedItem!, in: animation)
                )
                .zIndex(3)
                .transition(.modal)
            }
        }
    }

    func tapBackdrop() {
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                self.selectedItem = nil
                self.blur = false
            }
        }
    }

    func tapThumbnail(_ item: String, _ geometry: GeometryProxy) {
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                self.blur = true
                self.thumbnail_geo = geometry
                self.selectedItem = item
            }
        }
    }
}

struct Tester_Previews: PreviewProvider {
    static var previews: some View {
        Tester()
    }
}
