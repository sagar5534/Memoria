//
//  OnboardingScreen.swift
//  Memoria
//
//  Created by Sagar R Patel on 2021-10-03.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var selectedPage = 0
    
    var body: some View {
        VStack {
                TabView(selection: $selectedPage.animation()) {
                    IntroPanel()
                        .tag(0)
                    FeaturesPanel()
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack(alignment: .center) {
                    PageControl(currentPage: $selectedPage, numberOfPages: 2)
                        .frame(width: 40)

                    NavigationLink(
                        destination: SelectServer(),
                        label: {
                            Text("Get Started")
                                .bold()
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(.white)
                                )
                                .padding()
                        }
                    )
                        .foregroundColor(.secondary)
                    
                    Text("Create an account using the web interface")
                        .padding(3)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.all, 30)
            }
            .background(
                LinearGradient(gradient: Gradient(
                    colors: [
                        Color(UIColor.systemBackground).opacity(0.3),
                        Color(UIColor.systemBackground).opacity(0.6),
                        Color(UIColor.systemBackground).opacity(0.8),
                        Color(UIColor.systemBackground).opacity(1),
                    ]
                ), startPoint: .top, endPoint: .bottom)
            )
            .background(Image("TEST2").resizable().scaledToFill())
            .navigationBarHidden(true)
            .accentColor(.white)
            .preferredColorScheme(.dark)
        
    }
}

private struct IntroPanel: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15.0) {
                Text("Your \nphotos, \nin your hands.")
                    .bold()
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 50))
                    .lineSpacing(-10)
                
                Text("Memoria brings together all the media that matters to you. Your personal collection in a single app, on any device, no matter where you are.")
                    .multilineTextAlignment(.leading)
                    .font(.body)
            }
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.bottom)
    }
}

private struct FeaturesPanel: View {
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private var symbols = ["photo", "video", "livephoto", "slowmo", "desktopcomputer", "airplayvideo"]
    private var label = ["Photos", "Videos", "Live Photos", "Slow Motions", "Web Access", "Share"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            Text("Features")
                .bold()
                .multilineTextAlignment(.leading)
                .font(.system(size: 50))
                .lineSpacing(-10)
                .padding()
            
            LazyVGrid(columns: threeColumnGrid, spacing: 20) {
                ForEach(symbols.indices, id: \.self) { index in
                    VStack(alignment: .center) {
                        Image(systemName: symbols[index])
                            .font(.system(size: 30))
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                        Text(label[index])
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .padding()
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}
