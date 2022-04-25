//
//  Login.swift
//  Memoria
//
//  Created by Sagar R Patel on 2022-01-10.
//

import SwiftUI

struct SelectServer: View {
    @State private var serverURL: String = ""
    @ObservedObject var store: OBModel = .init()

    var body: some View {
        VStack(alignment: .leading, spacing: 15.0) {
            Spacer()
            Text("Connect")
                .bold()
                .multilineTextAlignment(.leading)
                .font(.system(size: 50))
                .lineSpacing(-10)
                .padding(.horizontal, 30)

            VStack(spacing: 15) {
                VStack(alignment: .center, spacing: 13) {
                    HStack {
                        TextField("Server URL", text: $serverURL) { Bool in
                            if Bool { store.isError = false }
                        } onCommit: {
                            guard !serverURL.isEmpty else { return }
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

                        NavigationLink(isActive: $store.showSignIn) {
                            SignInToServer(store: store)
                        } label: {}
                    }
                    Divider()
                        .background(Color.white)
                }

                HStack {
                    Text("The link to your Memoria web interface when you open it in the browser.")
                        .font(.system(size: 14))
                        .opacity(0.65)
                    Spacer()
                }
            }
            .padding(.all, 30)
            Spacer()
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
        .background(Image("TEST").resizable().scaledToFill())
        .navigationBarHidden(true)
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

struct SignInToServer: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @ObservedObject var store: OBModel

    var body: some View {
        
        var buttonWidth: CGFloat = {
           if UIDevice.current.userInterfaceIdiom == .phone {
               return UIScreen.main.bounds.width * 0.9
           } else {
               return UIScreen.main.bounds.width * 0.5
           }
        }()
        
        VStack(alignment: .leading, spacing: 15.0) {
            Spacer()
            Text("Sign In")
                .bold()
                .multilineTextAlignment(.leading)
                .font(.system(size: 50))
                .lineSpacing(-10)
                .padding(.horizontal, 30)

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
                    } else if store.isError {
                        Text("Incorrect credentials")
                            .font(.system(size: 14))
                            .opacity(0.95)
                    }
                    Spacer()
                }
                HStack {
                    Button(action: {}) {
                        Text("Forgot your password?")
                            .font(.system(size: 14))
                            .opacity(0.65)
                    }
                    Spacer()
                }
            }
            .padding(.all, 30)

            Button(action: {
                store.attempLogin(username: username, password: password)
            }) {
                Text("Sign In".uppercased())
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .frame(minWidth: buttonWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                    )
                    .padding()
                    .foregroundColor(.secondary)
            }
            .disabled(username == "" || password == "")
            .padding(.horizontal, 30)

            Spacer()
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
        .background(Image("TEST").resizable().scaledToFill())
        .navigationBarHidden(true)
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectServer()
        }
        NavigationView {
            SignInToServer(store: OBModel())
        }
    }
}
