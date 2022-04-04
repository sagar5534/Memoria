//
//  NavigationBar.swift
//  Chrono
//
//  Created by Sagar on 2021-06-15.
//

import SwiftUI
import UIKit

struct NavBar: ViewModifier {
    @State var title: String

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .navigationBarColor(backgroundColor: .systemBackground, tintColor: .label)
    }
}

struct InlineNavBar: ViewModifier {
    @State var title: String

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .systemBackground, tintColor: .label)
    }
}

struct NavigationBarColor: ViewModifier {
    init(backgroundColor: UIColor, tintColor: UIColor) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = backgroundColor
        coloredAppearance.titleTextAttributes = [.foregroundColor: tintColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: tintColor]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = tintColor

        let toolbarColor = UIToolbarAppearance()
        toolbarColor.configureWithOpaqueBackground()
        toolbarColor.backgroundColor = backgroundColor

        UIToolbar.appearance().standardAppearance = toolbarColor
        UIToolbar.appearance().compactAppearance = toolbarColor
        UIToolbar.appearance().tintColor = tintColor
    }

    func body(content: Content) -> some View {
        content
    }
}

struct FontedNavigationBar: ViewModifier {
    init() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 17)!]
        let largeAttributes = [NSAttributedString.Key.font: UIFont(name: "Pacifico-Regular", size: 26)!]
        let navBarAppearance = UINavigationBarAppearance()

        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titlePositionAdjustment.vertical = 1
        navBarAppearance.titleTextAttributes = attributes
        navBarAppearance.largeTitleTextAttributes = largeAttributes
        navBarAppearance.backButtonAppearance.normal.titleTextAttributes = attributes

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }

    func fontedNavigationBar() -> some View {
        modifier(FontedNavigationBar())
    }
}
