//
//  Navigation.swift
//  Navigation
//
//  Created by Sagar on 2021-09-03.
//

import SwiftUI

struct Navigation: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @ViewBuilder var body: some View {
        // Phone View
        if horizontalSizeClass == .compact {
            TabNavigation()
        }
        // Ipad View
        else {
            SidebarNavigation()
        }
    }
}

struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
