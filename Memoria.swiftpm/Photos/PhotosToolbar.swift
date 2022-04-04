//
//  PhotosToolbar.swift
//  Memoria
//
//  Created by Sagar on 2021-08-24.
//

import SwiftUI

struct PhotosToolbar: View {
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
                    Text(media?.creationDate.toDate()!.toString(withFormat: "d MMMM YYYY") ?? "")
                    Text(media?.creationDate.toDate()!.toString(withFormat: "h:mm a") ?? "")
                        .font(.caption)
                }
                .foregroundColor(.white)

                HStack {
                    Spacer()

                    Button(action: {
                        media?.isFavorite?.toggle()
                        
                        MNetworking.sharedInstance.updateMedia(media: media!) { 
                            print("Updating Media")
                        } completion: { result, errorCode, errorDescription in
                            print("Done Updating", result, errorCode, errorDescription)
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
                .alert(isPresented:$showingDeleteAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        primaryButton: .destructive(Text("Delete")) {
                            print("Deleting...")
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
        PhotosToolbar(media: .constant(nil), showShareSheet: .constant(false))
            .preferredColorScheme(.dark)
    }
}
