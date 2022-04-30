//
//  PhotosToolbar.swift
//  Memoria
//
//  Created by Sagar on 2021-08-24.
//

import SwiftUI

struct ModalToolbar: View {
    var onCloseTap: () -> Void = {}
    @Binding var media: Media?
    @Binding var showShareSheet: Bool
    @State private var showingDeleteAlert = false

    var body: some View {
        VStack(alignment: .center) {
            // --------------------------------------------------------
            // Top Bar
            // --------------------------------------------------------

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

                HStack(alignment: .center, spacing: 22) {
                    if media?.isLivePhoto ?? false {
                        Button(action: {}, label: {
                            Image(systemName: "play.circle")
                                .resizable()
                                .scaledToFit()
                        })
                        .foregroundColor(.white)
                        .contentShape(Rectangle())
                    }

                    Button(action: {
                        guard media != nil else { return }
                        media!.isFavorite?.toggle()

                        MNetworking.sharedInstance.updateMedia(media: media!) {
                            print("Updating Media")
                        } completion: { result, _, _ in
                            print("Done Updating Media", result as Any)
                        }

                    }, label: {
                        Image(systemName: media?.isFavorite ?? false ? "star.fill" : "star")
                            .resizable()
                            .scaledToFit()
                    })
                    .foregroundColor(.white)
                    .contentShape(Rectangle())

                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    })
                    .foregroundColor(.white)
                    .contentShape(Rectangle())
                }
                .frame(height: 20)
                .padding(.trailing)
            }
            .background(
                LinearGradient(colors: [.black.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea([.top, .leading, .trailing])
            )

            Spacer()

            // --------------------------------------------------------
            // Bottom Bar
            // --------------------------------------------------------

            VStack {
                if media?.mediaType == 1 {
                    VideoPlayerSlider()
                }

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

                    Button(action: { self.showingDeleteAlert.toggle() }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    })
                    .foregroundColor(.white)
                    .padding()
                    .contentShape(Rectangle())
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("Are you sure you want to delete this?"),
                            primaryButton: .destructive(Text("Delete")) {
                                print("Deleting...")
                                // Delete Media Command
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .background(
                LinearGradient(colors: [.black.opacity(0.5), .clear], startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea([.bottom, .leading, .trailing])
            )
        }
    }
}

struct PhotosToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ModalToolbar(media: .constant(nil), showShareSheet: .constant(false))
            .preferredColorScheme(.dark)
    }
}
