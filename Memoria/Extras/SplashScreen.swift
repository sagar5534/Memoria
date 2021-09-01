//
//  SplashScreen.swift
//  Memoria
//
//  Created by Sagar on 2021-08-16.
//

import SwiftUI

struct SplashScreen: View {
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                CombinedPhotos()
            } else {
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

private struct SplashView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            Image("Logo")
                .resizable()
                .scaledToFit()
                .offset(x: 0, y: -50.0)
                .padding(50)
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
