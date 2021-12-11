//
//  PhotoDetail.swift
//  PhotoDetail
//
//  Created by Sagar on 2021-09-26.
//

import SwiftUI

struct PhotoDetail: View {
    let namespace: Namespace.ID
    @Binding var details: Bool
    @Binding var media: Media?

    @State private var showShareSheet = false
    @State private var showToolbarButtons = true

    @State private var scale = CGSize.zero
    @State private var offset = CGSize.zero

    var body: some View {
        Group {
            // --------------------------------------------------------
            // Backdrop to blur the grid while the modal is displayed
            // --------------------------------------------------------
            Color.black
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .onTapGesture(count: 1) {
                    withAnimation {
                        showToolbarButtons.toggle()
                    }
                }

            // --------------------------------------------------------
            // Photo View
            // --------------------------------------------------------
            ZStack {
                GeometryReader { geo in
                    Thumbnail(item: media!)
                        .matchedGeometryEffect(id: media!.id, in: namespace)
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
                .transition(.modal)
            }
        }
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
                            details.toggle()
                        }
                    } else {
                        self.scale = .zero
                        self.offset = .zero
                    }
                }
        )

        // --------------------------------------------------------
        // Toolbar View
        // --------------------------------------------------------
        if showToolbarButtons {
            PhotosToolbar(onCloseTap: close, showShareSheet: $showShareSheet, media: $media)
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: [UIImage(named: "profile")])
                }
                .transition(.opacity)
        }
    }

    private func close() {
        DispatchQueue.main.async {
            details.toggle()
            showToolbarButtons = true
        }
    }
}
