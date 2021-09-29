//
//  UserImage.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI

struct UserImage: View {
    var body: some View {
        Image("profile")
            .resizable()
            .interpolation(.none)
            .scaledToFill()
            .frame(width: 32, height: 32, alignment: .center)
            .clipShape(Circle())
    }
}

struct UserImage_Previews: PreviewProvider {
    static var previews: some View {
        UserImage()
    }
}
