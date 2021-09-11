//
//  ContentView.swift
//  Hero Animation
//
//  Created by Kavsoft on 29/05/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
    @State var data = [
        Card(id: 0, image: "p2", title: "USA", details: "The U.S. is a country of 50 states covering a vast swath of North America, with Alaska in the northwest and Hawaii extending the nation’s presence into the Pacific Ocean. Major Atlantic Coast cities are New York, a global finance and culture center, and capital Washington, DC. Midwestern metropolis Chicago is known for influential architecture and on the west coast, Los Angeles' Hollywood is famed for filmmaking.", expand: false),
        Card(id: 1, image: "p3", title: "Canada", details: "Canada is a country in the northern part of North America. Its ten provinces and three territories extend from the Atlantic to the Pacific and northward into the Arctic Ocean, covering 9.98 million square kilometres, making it the world's second-largest country by total area.", expand: false),
        Card(id: 2, image: "p4", title: "Australia", details: "Australia, officially the Commonwealth of Australia, is a sovereign country comprising the mainland of the Australian continent, the island of Tasmania, and numerous smaller islands. It is the largest country in Oceania and the world's sixth-largest country by total area.", expand: false),
        Card(id: 3, image: "p5", title: "Germany", details: "Germany is a Western European country with a landscape of forests, rivers, mountain ranges and North Sea beaches. It has over 2 millennia of history. Berlin, its capital, is home to art and nightlife scenes, the Brandenburg Gate and many sites relating to WWII. Munich is known for its Oktoberfest and beer halls, including the 16th-century Hofbräuhaus. Frankfurt, with its skyscrapers, houses the European Central Bank.", expand: false),
        Card(id: 4, image: "p6", title: "Dubai", details: "Dubai is a city and emirate in the United Arab Emirates known for luxury shopping, ultramodern architecture and a lively nightlife scene. Burj Khalifa, an 830m-tall tower, dominates the skyscraper-filled skyline. At its foot lies Dubai Fountain, with jets and lights choreographed to music. On artificial islands just offshore is Atlantis, The Palm, a resort with water and marine-animal parks.", expand: false),
        
        Card(id: 5, image: "p1", title: "London", details: "London, the capital of England and the United Kingdom, is a 21st-century city with history stretching back to Roman times. At its centre stand the imposing Houses of Parliament, the iconic ‘Big Ben’ clock tower and Westminster Abbey, site of British monarch coronations. Across the Thames River, the London Eye observation wheel provides panoramic views of the South Bank cultural complex, and the entire city.", expand: false)
    ]
    
    @State var selected: Card?
    @State var show = false
    @Namespace var nspacetest
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Text("Travel")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .padding([.horizontal, .top])
                
                
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(data) { travel in
                        VStack(alignment: .leading, spacing: 10) {
                            Image(travel.image)
                                .resizable()
                                .matchedGeometryEffect(id: travel.id, in: nspacetest)
                                .frame(height: 180)
                                .cornerRadius(15)
                                .onTapGesture {
                                    selected = travel
                                    show.toggle()
                                }
                            
                            Text(travel.title)
                        }
                    }
                }
                .padding()
            }
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            
            // Here View
            if show {
                VStack {
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        Image(selected!.image)
                            .resizable()
                            .matchedGeometryEffect(id: selected!.id, in: nspacetest)
                            .frame(height: 300)
                        
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.spring()) {
                                    show.toggle()
                                    selected = nil
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// card View...

struct CardView: View {
    @Binding var data: Card
    @Binding var hero: Bool
    
    var body: some View {
        // going to implement close button...
        
        ZStack(alignment: .topTrailing) {
            VStack {
                Image(self.data.image)
                    .resizable()
                    .frame(height: self.data.expand ? 350 : 250)
                    .cornerRadius(self.data.expand ? 0 : 25)
                
                if self.data.expand {
                    HStack {
                        Text(self.data.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Text(self.data.details)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("Details")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack(spacing: 0) {
                        Button(action: {}) {
                            Image("mcard1")
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {}) {
                            Image("mcard2")
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {}) {
                            Image("mcard3")
                        }
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {}) {
                            Image("mcard4")
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        Text("Let's Go")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width / 2)
                            .background(LinearGradient(gradient: .init(colors: [Color("Color"), Color("Color1")]), startPoint: .leading, endPoint: .trailing))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 15)
                }
            }
            .padding(.horizontal, self.data.expand ? 0 : 20)
            // to ignore spacer scroll....
            .contentShape(Rectangle())
            
            // showing only when its expanded...
            
            if self.data.expand {
                Button(action: {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                        self.data.expand.toggle()
                        self.hero.toggle()
                    }
                    
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                .padding(.trailing, 10)
            }
        }
    }
}

// sample Data..

struct Card: Identifiable {
    var id: Int
    var image: String
    var title: String
    var details: String
    var expand: Bool
}
