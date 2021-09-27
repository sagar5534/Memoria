//
//  Loader.swift
//  Loader
//
//  Created by Sagar on 2021-09-25.
//

import Lottie
import SwiftUI

struct Loader: View {
    var body: some View {
        VStack {
            Text("Memoria")
                .font(.custom("Pacifico-Regular", size: 30))
                .foregroundColor(Color("PhotoLoading"))

            Spacer()
            LottieView(filename: "loading-dots")
                .frame(width: 300, height: 300, alignment: .center)
            Spacer()
        }
    }
}

struct FullScreenLoader: View {
    var body: some View {
        ZStack {
            Color("PhotoLoading")
                .ignoresSafeArea()
            VStack {
                Text("Memoria")
                    .font(.custom("Pacifico-Regular", size: 30))
                    .foregroundColor(.white)
            }
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
        FullScreenLoader()
    }
}
