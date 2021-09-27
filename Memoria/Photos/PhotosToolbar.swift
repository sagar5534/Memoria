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
    private let size: CGFloat = 20

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button(action: { onCloseTap() }, label: {
                    Label(
                        title: { Text("Back") },
                        icon: { Image(systemName: "chevron.backward").font(.system(size: size))
                        }
                    )
                    .padding()
                })
                    .contentShape(Rectangle())
                Spacer()
            }
            Spacer()

            HStack {
                Button(action: { self.showShareSheet.toggle() }, label: {
                    Label(
                        title: {},
                        icon: { Image(systemName: "square.and.arrow.up").font(.system(size: size)) }
                    )
                    .padding()
                })
                    .foregroundColor(.white)
                Spacer()
                Button(action: {}, label: {
                    Label(
                        title: {},
                        icon: { Image(systemName: "trash").font(.system(size: size)) }
                    )
                    .padding()
                })
                    .foregroundColor(.red)
            }
        }
    }
}

struct PhotosToolbar_Previews: PreviewProvider {
    static var previews: some View {
        PhotosToolbar(showShareSheet: .constant(false))
    }
}
