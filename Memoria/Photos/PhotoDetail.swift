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

    var body: some View {
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
                    .onTapGesture(count: 1) {
                        withAnimation {
                            showToolbarButtons.toggle()
                        }
                    }
            }
            .transition(.modal)
        }

        // --------------------------------------------------------
        // Toolbar View
        // --------------------------------------------------------
        if showToolbarButtons {
            PhotosToolbar(onCloseTap: close, showShareSheet: $showShareSheet)
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
