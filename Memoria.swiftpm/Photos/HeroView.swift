//
//  HeroView.swift
//  HeroAnimations
//
//  Created by SwiftUI-Lab on 04-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part1
//

import SwiftUI
import Combine

struct HeroView: View {
    @Namespace var nspace
    @Environment(\.colorScheme) var scheme
    
    @State private var selectedItem: Media? = nil
    @State private var blur = false
    @State private var isPortrait: Bool?
        
    @State private var scaler: CGFloat = 120
    
    @ObservedObject var photoGridData = PhotoGridData()

//    @State var groupedMedia: SortedMediaCollection
    @State private var showShareSheet = false
    @State private var showToolbarButtons = true
    
    @State private var scale = CGSize.zero
    @State private var offset = CGSize.zero
    
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
    //                                        Color.red
                                            Thumbnail(item: photoGridData.groupedMedia[i][index])
                                                .onTapGesture {
                                                    tapThumbnail(photoGridData.groupedMedia[i][index]) }
                                                .scaledToFill()
                                                .layoutPriority(-1)
                                                .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: nspace, isSource: true)
                                                .transition(.invisible)

                                        }
                                    }
                                    .clipped()
                                    .zIndex(selectedItem?.id == photoGridData.groupedMedia[i][index].id ? 100 : 1)
                                    .aspectRatio(1, contentMode: .fit)
//                                    .id(photoGridData.groupedMedia[i][index].id)
                                    .id(UUID())

                                }
                            }
                            .id(UUID())
                        }
                    }
                    .navigationTitle(Text("Our Food Service"))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .zIndex(1)
            
            
            // --------------------------------------------------------
            // Backdrop to blur the grid while the modal is displayed
            // --------------------------------------------------------
            if blur {
//                Color.black
//                    .edgesIgnoringSafeArea(.all)
//                    .onTapGesture(perform: tapBackdrop)
//                    .transition(.opacity)
//                    .zIndex(2)
            }
            
            // --------------------------------------------------------
            // Modal view
            // --------------------------------------------------------
            if self.selectedItem != nil {
                Color.clear.overlay(
                    
                    GeometryReader { geo in
                        FullResImage(item: selectedItem!)
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .scaleEffect(
                                scale.height < 50 ?
                                1 - ((scale.height / 100) / 3) :
                                    0.866
                            )
                            .animation(.linear(duration: 0.1), value: scale)
                            .offset(x: offset.width, y: offset.height)
                            .onTapGesture(count: 1) {
                                withAnimation {
                                    showToolbarButtons.toggle()
                                }
                            }
                    }
                        .matchedGeometryEffect(id: self.selectedItem!.id, in: nspace, properties: .position)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.height >= 0 {
                                        self.scale = gesture.translation
                                    }
                                    self.offset = gesture.translation
                                }
                                .onEnded { gesture in
                                    if gesture.translation.height > 50 {
                                        withAnimation {
                                            tapBackdrop()
                                        }
                                    } else {
                                        self.scale = .zero
                                        self.offset = .zero
                                    }
                                }
                        )
                )
                .zIndex(3)
                .transition(.modal)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            print(photoGridData.groupedMedia.count)
        }
    }
    
    /// When the backdrop is tapped, close the modal and unblur the screen
    func tapBackdrop() {
        print("Back")
        self.blur = false
        offset = CGSize.zero
        scale = CGSize.zero

        DispatchQueue.main.async {
            withAnimation(.easeIn(duration: 0.1)) { self.selectedItem = nil }
        }
    }
    
    /// Blur the screen and open a modal on top.
    func tapThumbnail(_ item: Media) {
        print("Enter")
        withAnimation(.easeIn(duration: 0.1)) { self.selectedItem = item }

        DispatchQueue.main.async {
            self.blur = true
        }
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

