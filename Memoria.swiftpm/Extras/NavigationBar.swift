//
//  NavigationBar.swift
//  Chrono
//
//  Created by Sagar on 2021-06-15.
//

import SwiftUI
import UIKit

struct DefaultNavigationBar: ViewModifier {
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.myBackground
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
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

        navBarAppearance.backgroundColor = UIColor.myBackground
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
    func fontedNavigationBar() -> some View {
        modifier(FontedNavigationBar())
            .background(Color.myBackground)

    }

    func defaultNavigationBar() -> some View {
        modifier(DefaultNavigationBar())
            .background(Color.myBackground)

    }
}

