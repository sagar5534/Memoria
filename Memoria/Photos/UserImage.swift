//
//  UserImage.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI

struct UserImage: View {
    var body: some View {
        Image("IMG_2")
            .resizable()
            .interpolation(.none)
            .scaledToFill()
            .frame(width: 32, height: 32, alignment: .center)
            .clipShape(Circle())

//            .resizable()
//            .frame(width: 40, height: 40, alignment: .center)
//            .clipShape(Circle())
//            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//            .shadow(radius: 7)
    }
}

struct UserImage_Previews: PreviewProvider {
    static var previews: some View {
        UserImage()
    }
}
