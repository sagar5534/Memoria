//
//  PhotoView.swift
//  PhotoView
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

struct HeroView: View {
    @Namespace var namespace
    @ObservedObject var photoGridData = PhotoGridData()

    @State private var selectedItem: Media? = nil
    @State private var scaler: CGFloat = 120
    @State private var showShareSheet = false
    @State private var showModalToolbar = true
    @State private var modalScale = CGSize.zero
    @State private var modalOffset = CGSize.zero

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: scaler), spacing: 2)]

        return ZStack {
            // --------------------------------------------------------
            // NavigationView with LazyVGrid
            // --------------------------------------------------------
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                            Section(header: titleHeader(header: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                                ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                                    ZStack {
                                        Color.clear
                                        if self.selectedItem?.id != photoGridData.groupedMedia[i][index].id {
                                            Thumbnail(item: photoGridData.groupedMedia[i][index])
                                                .onTapGesture {
                                                    openModal(photoGridData.groupedMedia[i][index])
                                                }
                                                .scaledToFill()
                                                .layoutPriority(-1)
                                        }
                                    }
                                    .clipped()
                                    .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: namespace)
                                    .zIndex(selectedItem?.id == photoGridData.groupedMedia[i][index].id ? 100 : 1)
                                    .aspectRatio(1, contentMode: .fit)
                                    .id(photoGridData.groupedMedia[i][index].id)
                                }
                            }
                            .id(UUID())
                        }
                    }
                    .navigationTitle("Memoria")
                    .fontedNavigationBar() // Experiemental
                    .onDisappear {
                        let navBarAppearance = UINavigationBarAppearance()
                        navBarAppearance.configureWithOpaqueBackground()
                        UINavigationBar.appearance().standardAppearance = navBarAppearance
                        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
                    }
                }
            }
            .navigationViewStyle(.stack)
            .zIndex(1)
            
            // --------------------------------------------------------
            // Modal view
            // --------------------------------------------------------
            if self.selectedItem != nil {
                Group {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: closeModal)
                        .transition(.opacity)
                        .zIndex(2)
                    
                    GeometryReader { geo in
                        FullResImage(item: self.selectedItem!)
                            .matchedGeometryEffect(id: self.selectedItem!.id, in: namespace)
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .scaleEffect(
                                modalScale.height < 50 ?
                                    1 - ((modalScale.height / 100) / 3) :
                                    0.866
                            )
                            .animation(.linear(duration: 0.1), value: modalScale)
                            .offset(x: modalOffset.width, y: modalOffset.height)
                            .onTapGesture(count: 1) {
                                withAnimation {
                                    showModalToolbar.toggle()
                                }
                            }
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.height >= 0 {
                                self.modalScale = gesture.translation
                            }
                            self.modalOffset = gesture.translation
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 50 {
                                closeModal()
                            } else {
                                self.modalScale = .zero
                                self.modalOffset = .zero
                            }
                        }
                )
                .zIndex(3)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func closeModal() {
        self.modalScale = .zero
        self.modalOffset = .zero
        withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) { self.selectedItem = nil }
    }
    
    private func openModal(_ item: Media) {
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) { self.selectedItem = item }
    }
}

private struct titleHeader: View {
    let header: String
    
    var body: some View {
        Text(header)
            .font(.custom("OpenSans-SemiBold", size: 14))
            .foregroundColor(.primary)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
