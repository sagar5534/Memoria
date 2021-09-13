//
//  Photos.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI

struct PhotoGrid: View {
    @ObservedObject var photoGridData = PhotoGridData()
    @State var selected: Bool = false
    @Binding var media: Media?

    var onThumbnailTap: (_ item: Media) -> Void = { _ in }
    var namespace: Namespace.ID
    let columns =
        [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
        ]

    var body: some View {
        Text("")
    }
}

func titleHeader(with header: String) -> some View {
    Text(header)
        .font(.body)
        .bold()
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
}

struct PullToRefresh: View {
    var coordinateSpaceName: String
    var onRefresh: () -> Void
    @Namespace private var nspace
    @State var needRefresh: Bool = false

    var body: some View {
        GeometryReader { geo in

            if geo.frame(in: .named(coordinateSpaceName)).midY > 50 {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if geo.frame(in: .named(coordinateSpaceName)).maxY < 10 {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            withAnimation {
                                needRefresh = false
                            }
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                        .matchedGeometryEffect(id: "reload", in: nspace)
                        .onAppear {
                            simpleSuccess()
                        }

                } else {
                    Image(systemName: "arrow.clockwise")
                        .rotationEffect(Angle.degrees((geo.frame(in: .named(coordinateSpaceName)).maxY + 40) * 3.789))
                        .matchedGeometryEffect(id: "reload", in: nspace)
//                        .transition(.fade)
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

func simpleSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

struct Photos_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PhotoGrid(media: .constant(nil), namespace: Namespace().wrappedValue)
                .previewDevice("iPhone 11")
                .preferredColorScheme(.light)
                .modifier(InlineNavBar(title: "Memoria"))
        }
    }
}
