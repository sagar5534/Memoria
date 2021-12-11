//
//  PhotosToolbar.swift
//  Memoria
//
//  Created by Sagar on 2021-08-24.
//

import SwiftUI

struct PhotosToolbar: View {
    var onCloseTap: () -> Void = {}
    @Binding var showShareSheet: Bool
    @Binding var media: Media?

    var body: some View {
        var isFav = media?.isFavorite

        VStack(alignment: .center) {
            // --------------------------------------------------------
            // Top Bar
            // --------------------------------------------------------
            ZStack {
                HStack {
                    Button(action: { onCloseTap() }, label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                    })
                    .foregroundColor(.white)
                    .padding()
                    .contentShape(Rectangle())

                    Spacer()
                }

                VStack {
                    Text("Today")
                    Text("9:31 pm")
                        .font(.caption)
                }
                .foregroundColor(.white)

                HStack {
                    Spacer()

                    Button(action: {
                        media?.isFavorite.toggle()
                        print(media)
                    }, label: {
                        Image(systemName: media?.isFavorite ?? false ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 18)
                    })
                    .foregroundColor(.white)
                    .padding()
                    .contentShape(Rectangle())
                }
            }

            Spacer()

            // --------------------------------------------------------
            // Bottom Bar
            // --------------------------------------------------------
            HStack {
                Button(action: { self.showShareSheet.toggle() }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                })
                .foregroundColor(.white)
                .padding()
                .contentShape(Rectangle())

                Spacer()

                Button(action: { self.showShareSheet.toggle() }, label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                })
                .foregroundColor(.red)
                .padding()
                .contentShape(Rectangle())
            }
        }
    }
}

struct PhotosToolbar_Previews: PreviewProvider {
    static var previews: some View {
        PhotosToolbar(showShareSheet: .constant(false), media: .constant(nil))
            .preferredColorScheme(.dark)
    }
}
