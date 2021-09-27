//
//  Photos.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI

struct PullToRefresh: View {
    var coordinateSpaceName: String
    var onRefresh: () -> Void
    @Namespace private var nspace
    @State var needRefresh: Bool = false

    var body: some View {
        GeometryReader { geo in

            if geo.frame(in: .named(coordinateSpaceName)).midY > 80 {
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
                }
                Spacer()
            }
        }.padding(.top, -80)
    }

    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
