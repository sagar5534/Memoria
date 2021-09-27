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
                Navigation()
            } else {
                FullScreenLoader()
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

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
