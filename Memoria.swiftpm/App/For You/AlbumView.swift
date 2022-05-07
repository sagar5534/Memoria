//
//  SwiftUIView.swift
//
//
//  Created by Sagar R Patel on 2022-05-05.
//

import SwiftUI

struct AlbumView: View {
    let namespace: Namespace.ID
    @EnvironmentObject var modalSettings: ModalSettings
    @State private var scaler = 2

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: scaler)
            
        if modalSettings.selectedAlbum {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            modalSettings.selectedAlbum = false
                        }
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                    })
                    .padding()
                    .contentShape(Rectangle())

                    Spacer()

                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    })
                    .padding()
                    .contentShape(Rectangle())
                }
                
                ScrollView {
                    VStack {
                        Group {
                            Text("Hello")
                                .font(.title)
                                .foregroundColor(.primary)
                                .padding()
                                .padding(.top, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        
                            Text("200 Items")
                                .font(.caption)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        thumbnailIcon()
                        
                        LazyVGrid(columns: columns, spacing: 2) {
                            thumbnailIcon()
                            thumbnailIcon()
                            thumbnailIcon()
                            thumbnailIcon()
                            thumbnailIcon()
                        }
                    }
                }
            }
            .matchedGeometryEffect(id: 122, in: namespace)
            .background(Color.white)
        }
    }
}

private struct thumbnailIcon: View {
//    let namespace: Namespace.ID
//    let media: Media

    var body: some View {
        VStack(spacing: 0) {
            Color.clear
                .overlay(
                    Image("profile")
                        .resizable()
                        .aspectRatio(nil, contentMode: .fill)
                        .contentShape(Circle())
                )
                .clipped()
                .aspectRatio(1, contentMode: .fit)
        }
    }
}
