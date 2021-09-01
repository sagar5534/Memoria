//
//  Test.swift
//  Memoria
//
//  Created by Sagar on 2021-08-17.
//

import SwiftUI

struct ScrollBarIcon: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.red)
            .frame(width: 40, height: 40)
    }
}

struct ScrollBarIcon_Preview: PreviewProvider {
    static var previews: some View {
        ScrollBarIcon()
    }
}
