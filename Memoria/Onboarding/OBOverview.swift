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
        ScrollView {
            VStack {
                TabView(selection: $selectedPage.animation()) {
                    ForEach(data.indices) { index in
                        OBOverview_View(data: data[index])
                            .tag(index)
                    }

                    Login(store: OBStore())
                        .tag(data.count)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(alignment: .center) {
                    PageControl(currentPage: $selectedPage, numberOfPages: 3)
                        .frame(width: 40)
                    Spacer()

                    if selectedPage != data.count {
                        Button(action: {
                            withAnimation {
                                selectedPage = data.count
                            }
                        }, label: {
                            Text("Skip")
                                .bold()
                        })
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(.dark)
    }
}

private struct OBOverview_View: View {
    let data: OnboardingModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(data.asset)
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height - 100
                )
                .clipped()

            LinearGradient(gradient: Gradient(
                colors: [
                    Color(UIColor.systemBackground).opacity(0),
                    Color(UIColor.systemBackground).opacity(0.3),
                    Color(UIColor.systemBackground).opacity(0.5),
                    Color(UIColor.systemBackground).opacity(1),
                ]
            ), startPoint: .top, endPoint: .bottom)

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
}

private struct Login: View {
    @State private var serverURL: String = ""
    @State private var username: String = ""
    @State private var password: String = ""

    @ObservedObject var store: OBStore

    var body: some View {
        ZStack(alignment: .center) {
            Image("TEST3")
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height - 100
                )
                .clipped()

            LinearGradient(gradient: Gradient(
                colors: [
                    Color(UIColor.systemBackground).opacity(0.6),
                    Color(UIColor.systemBackground).opacity(0.7),
                    Color(UIColor.systemBackground).opacity(0.8),
                    Color(UIColor.systemBackground).opacity(1),
                ]
            ), startPoint: .top, endPoint: .bottom)

            VStack {
                if !store.showSignIn {
                    loginView
                } else {
                    signInView
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom)
            .transition(.slide)
        }
    }

    var loginView: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            Text("Connect")
                .bold()
                .multilineTextAlignment(.leading)
                .font(.system(size: 50))
                .lineSpacing(-10)
                .padding(.bottom)

            VStack(spacing: 15) {
                VStack(alignment: .center, spacing: 13) {
                    HStack {
                        TextField("Server URL", text: $serverURL) { Bool in
                            if Bool { store.isError = false }
                        } onCommit: {
                            if !serverURL.lowercased().hasPrefix("http") {
                                serverURL = "https://" + serverURL
                            }
                            store.pingServer(url: serverURL)
                        }
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .font(.system(size: 18))

                        if store.running {
                            ProgressView()
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        } else if store.isError {
                            Image(systemName: "exclamationmark.icloud")
                                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                        } else {
                            Image(systemName: "arrow.right")
                        }
                    }

                    Divider()
                        .background(Color.white)
                }

                HStack {
                    Text("The link to your Memoria web interface when you open it in the browser.")
                        .modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.white.opacity(0.65)))
                    Spacer()
                }
            }
        }
    }

    var signInView: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            Text("Sign In")
                .bold()
                .multilineTextAlignment(.leading)
                .font(.system(size: 50))
                .lineSpacing(-10)
                .padding(.bottom)

            VStack(spacing: 15) {
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center) {
                        TextField("Username", text: $username)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .font(.system(size: 18))

                        Divider()
                            .background(Color.white)
                    }
                    VStack(alignment: .center) {
                        SecureField("Password", text: $password) {
                            if username != "", password != "" {
                                store.attempLogin(username: username, password: password)
                            }
                        }
                        .autocapitalization(.none)
                        .font(.system(size: 18))

                        Divider()
                            .background(Color.white)
                    }
                }

                HStack {
                    if store.running {
                        ProgressView()
                            .animation(.easeIn)
                    } else if store.isError {
                        Text("Incorrect credentials")
                            .modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.red.opacity(0.95)))
                            .animation(.easeIn)
                    }
                    Spacer()
                }
   
                HStack {
                    // TODO:
                    Button(action: {}) {
                        Text("Forgot your password?")
                            .modifier(CustomTextM(fontName: "OpenSans-Regular", fontSize: 14, fontColor: Color.white.opacity(0.65)))
                    }
                    Spacer()
                }
            }

            Button(action: {
                store.attempLogin(username: username, password: password)
            }) {
                Text("login".uppercased())
                    .accentColor(.black)
                    .font(.custom("OpenSans-Regular", size: 14))
                    .modifier(ButtonStyle(buttonHeight: 60, buttonColor: Color.white, buttonRadius: 10))
                    .animation(.default)
            }
            .disabled(username == "" || password == "")
            .padding(.top, 30)
        }
    }
}

private struct CustomTextM: ViewModifier {
    // MARK: - PROPERTIES

    let fontName: String
    let fontSize: CGFloat
    let fontColor: Color

    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
            .foregroundColor(fontColor)
    }
}

private struct ButtonStyle: ViewModifier {
    // MARK: - PROPERTIES

    let buttonHeight: CGFloat
    let buttonColor: Color
    let buttonRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(buttonColor)
            .cornerRadius(buttonRadius)
    }
}

struct Onboarding_Overview_Previews: PreviewProvider {
    static var previews: some View {
//        Login(store: OBStore())
        OBOverview()
    }
}
