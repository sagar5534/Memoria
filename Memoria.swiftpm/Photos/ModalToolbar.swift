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
                    Text(media?.creationDate.toDate()!.toString(withFormat: "d MMMM YYYY") ?? "Today")
                    Text(media?.creationDate.toDate()!.toString(withFormat: "h:mm a") ?? "12:00 AM")
                        .font(.caption)
                }
                .foregroundColor(.white)

                HStack {
                    Spacer()

                    Button(action: {
                        guard media != nil else { return }
                        media!.isFavorite?.toggle()

                        MNetworking.sharedInstance.updateMedia(media: media!) {
                            print("Updating Media")
                        } completion: { result, _, _ in
                            print("Done Updating Media", result)
                        }

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

                Button(action: { self.showingDeleteAlert.toggle() }, label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                })
                .foregroundColor(.red)
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
    }
}

struct PhotosToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ModalToolbar(media: .constant(nil), showShareSheet: .constant(false))
            .preferredColorScheme(.dark)
    }
}
