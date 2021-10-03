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
    )
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
                    
                    Login()
                        .tag(data.count + 1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                
                HStack(alignment: .center) {
                    PageControl(currentPage: $selectedPage, numberOfPages: 3)
                        .frame(width: 40)
                    Spacer()
                    
                    if (selectedPage != data.count + 1) {
                        Button(action: {
                            withAnimation {
                                selectedPage = data.count + 1
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
                    width: UIScreen.main.bounds.width ,
                    height: UIScreen.main.bounds.height - 100
                )
                .clipped()
            
            LinearGradient(gradient: Gradient(
                colors: [
                    Color(UIColor.systemBackground).opacity(0),
                    Color(UIColor.systemBackground).opacity(0.3),
                    Color(UIColor.systemBackground).opacity(0.5),
                    Color(UIColor.systemBackground).opacity(1)
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
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Image("TEST3")
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width ,
                    height: UIScreen.main.bounds.height - 100
                )
                .clipped()
            
            
            LinearGradient(gradient: Gradient(
                colors: [
                    Color(UIColor.systemBackground).opacity(0),
                    Color(UIColor.systemBackground).opacity(0.3),
                    Color(UIColor.systemBackground).opacity(0.5),
                    Color(UIColor.systemBackground).opacity(1)
                ]
            ), startPoint: .top, endPoint: .bottom)
            
            
            HStack {
                VStack(alignment: .leading, spacing: 15.0) {
                    Text("Login")
                        .bold()
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 50))
                        .lineSpacing(-10)
                    
                    Text("Sign into your account to access your library")
                        .multilineTextAlignment(.leading)
                        .font(.body)
                    
                    Button(action: {
                        withAnimation {
                            
                        }
                    }, label: {
                        Text("Go To App")
                            .bold()
                    })
                    .foregroundColor(.secondary)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.bottom)
            
        }
        
    }
}

struct Onboarding_Overview_Previews: PreviewProvider {
    static var previews: some View {
        OBOverview()
            .preferredColorScheme(.dark)
    }
}
