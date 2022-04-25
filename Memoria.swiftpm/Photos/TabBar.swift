//
//  PhotosView.swift
//  PhotosView
//
//  Created by Sagar on 2021-09-10.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var tabSelected: Int
    @Binding var scrollToTop: Bool
    private let circleSize: CGFloat = 4

    @ViewBuilder
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 5) {
                NavBarItem(tabSelected: $tabSelected, scrollToTop: $scrollToTop, tag: 0, icon: "house")
                Circle()
                    .frame(height: circleSize, alignment: .center)
                    .foregroundColor(tabSelected == 0 ? Color.primary : Color.clear)
            }
            .frame(width: 40, alignment: .center)

            Spacer()
            VStack(alignment: .center, spacing: 5) {
                NavBarItem(tabSelected: $tabSelected, scrollToTop: $scrollToTop, tag: 1, icon: "square.stack")

                Circle()
                    .frame(height: circleSize, alignment: .center)
                    .foregroundColor(tabSelected == 1 ? Color.primary : Color.clear)
            }
            .frame(width: 40, alignment: .center)

            Spacer()
            VStack(alignment: .center, spacing: 5) {
                NavBarItem(tabSelected: $tabSelected, scrollToTop: $scrollToTop, tag: 2, icon: "magnifyingglass")
                Circle()
                    .frame(height: circleSize, alignment: .center)
                    .foregroundColor(tabSelected == 2 ? Color.primary : Color.clear)
            }
            .frame(width: 40, alignment: .center)
            Spacer()

            VStack(alignment: .center, spacing: 5) {
                NavBarItem(tabSelected: $tabSelected, scrollToTop: $scrollToTop, tag: 3, icon: "person")
                Circle()
                    .frame(height: circleSize, alignment: .center)
                    .foregroundColor(tabSelected == 3 ? Color.primary : Color.clear)
            }
            .frame(width: 40, alignment: .center)
            Spacer()
        }
        .foregroundColor(.primary)
        .padding(.vertical, 8)
        .padding(.top, 5)
        .frame(height: UITabBarController().tabBar.frame.size.height)
        .background(.background)
    }
}

private struct NavBarItem: View {
    @Binding var tabSelected: Int
    @Binding var scrollToTop: Bool
    var tag: Int
    var icon: String

    @ViewBuilder
    var body: some View {
        Button(action: {
            if tabSelected == tag {
                scrollToTop.toggle()
            }
            tabSelected = tag
        }) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(tabSelected: .constant(0), scrollToTop: .constant(false))
    }
}
