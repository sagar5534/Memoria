//
//  Onboarding_Overview.swift
//  Memoria
//
//  Created by Sagar R Patel on 2021-10-03.
//

import SwiftUI

struct OnboardingModel: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let asset: String
}

private let data: [OnboardingModel] = [
    OnboardingModel(
        title: "Your \nphotos, \nin your hands.",
        detail: "Memoria brings together all the media that matters to you. Your personal collection in a single app, on any device, no matter where you are.",
        asset: "TEST2"
    ),
    OnboardingModel(
        title: "Lorem Ipsum",
        detail: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam a nibh nec justo convallis semper. Morbi pretium erat felis, id suscipit arcu tincidunt",
        asset: "TEST"
    ),
]

struct OBOverview: View {
    @State private var selectedPage = 0

    var body: some View {
        NavigationView {
            ZStack {
                Image("TEST2")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: UIScreen.main.bounds.width
                    )
                    .clipped()
                    .overlay(
                        LinearGradient(gradient: Gradient(
                            colors: [
                                Color(UIColor.systemBackground).opacity(0.3),
                                Color(UIColor.systemBackground).opacity(0.6),
                                Color(UIColor.systemBackground).opacity(0.8),
                                Color(UIColor.systemBackground).opacity(1),
                            ]
                        ), startPoint: .top, endPoint: .bottom)
                    )

                VStack {
                    TabView(selection: $selectedPage.animation()) {
                        ForEach(data.indices) { index in
                            OBOverview_View(data: data[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                    VStack(alignment: .center) {
                        PageControl(currentPage: $selectedPage, numberOfPages: data.count)
                            .frame(width: 40)
                            .padding()

                        NavigationLink(
                            destination: Login(),
                            label: {
                                Text("Get Started")
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(
                                        width: UIScreen.main.bounds.width - 150
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 50)
                                            .foregroundColor(.white)
                                    )
                            }
                        )
                        .foregroundColor(.secondary)

                        Text("Create an account using the web interface")
                            .padding(3)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .preferredColorScheme(.dark)
            .navigationBarHidden(true)
        }
        .accentColor(.white)
    }
}

private struct OBOverview_View: View {
    let data: OnboardingModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15.0) {
                Text(data.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 50))
                    .lineSpacing(-10)

                Text(data.detail)
                    .multilineTextAlignment(.leading)
                    .font(.body)
            }
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.bottom)
    }
}

struct Onboarding_Overview_Previews: PreviewProvider {
    static var previews: some View {
        OBOverview()
    }
}
