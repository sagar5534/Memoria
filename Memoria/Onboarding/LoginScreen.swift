//
//  Login.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-01-10.
//

import SwiftUI

struct LoginScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var serverURL: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @ObservedObject var store: OBModel = OBModel()

    var body: some View {
        ZStack {
            Image("TEST")
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
                if !store.showSignIn {
                    ConnectServer
                } else {
                    SignInToServer
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom)
            .transition(.slide)
        }
        .edgesIgnoringSafeArea(.top)
        .preferredColorScheme(.dark)
    }

    var ConnectServer: some View {
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
                            guard !serverURL.isEmpty else {return}
                            if !serverURL.lowercased().hasPrefix("http") {
                                serverURL = "https://" + serverURL
                            }
                            if serverURL.hasSuffix("/") {
                                serverURL = String(serverURL.dropLast())
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

    var SignInToServer: some View {
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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginScreen()
        }
    }
}
