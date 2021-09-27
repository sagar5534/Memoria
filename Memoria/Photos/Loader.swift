//
//  Loader.swift
//  Loader
//
//  Created by Sagar on 2021-09-25.
//

import SwiftUI
import Lottie

struct Loader: View {
    var body: some View {
        VStack {
            Text("Memoria")
                .font(.custom("Pacifico-Regular", size: 30))
                .foregroundColor(Color("PhotoLoading"))
            
            Spacer()
            LottieView(filename: "airplane-loading")
                .frame(width: 300, height: 300, alignment: .center)
            Spacer()
        }
        
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
