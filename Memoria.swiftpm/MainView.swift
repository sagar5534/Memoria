//
//  MainView.swift
//  Memoria
//
//  Created by Sagar on 2021-06-23.
//

import Foundation
import SwiftUI

struct MainView: View {
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if self.isActive {
                MotherView()
            } else {
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

private struct MotherView: View {
    @AppStorage("signedIn") private var signedIn: Bool = true

    var body: some View {
        VStack {
            if signedIn {
                NavigationView {
                    PhotosView()
                }
                .navigationViewStyle(.stack)
                .transition(.opacity)
            } else {
                NavigationView {
                    OnboardingScreen()
                }
                .navigationViewStyle(.stack)
                .transition(.opacity)
            }
        }
    }
}

private struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            let x = colorScheme == .dark ? Color.black : Color.white
            x.ignoresSafeArea()
            VStack {
                Text("Memoria")
                    .font(.custom("Pacifico-Regular", size: 30))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
        MainView()
            .preferredColorScheme(.dark)
    }
}
