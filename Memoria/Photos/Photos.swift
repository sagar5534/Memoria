//
//  Photos.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI

struct Photos: View {
    let data = (1 ... 8).map { "IMG_\($0)" }
    let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
    ]

    @ObservedObject var model = NetworkManager.sharedInstance

    var month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let curYear = Calendar.current.component(.year, from: Date())

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(model.data, id: \.self) { collection in

                // Month Label
                Leading {
                    let tempYear = (collection.year == curYear) ? "" : ", \(String(collection.year))"
                    Text("\(month[collection.month])\(tempYear)")
                        .font(.title)
                        .padding(.leading)
                        .padding(.top, 50)
                }

                ForEach(collection.data, id: \.self) { media in

                    // Day Label
                    Leading {
                        let x: Date = media.first!.dateModified.toDate()!
                        Text(x.toString())
                            .font(.subheadline)
                            .padding(.leading)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                    }

                    // Photo Grid
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(media, id: \.self) { _ in
//                            AsyncImage(
//                                url: URL(string: "http://192.168.100.107:3000/data/\(item.path)")!,
//                                placeholder: { ProgressView() },
//                                image: {
//                                    Image(uiImage: $0)
//                                        .resizable()
//                                }
//                            )
//                            .scaledToFill()
//                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
//                            .clipped()
                            Text("")
                        }
                    }
                }
            }
        }
        .navigationTitle("Memoria")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            Button(action: {
//                model.upload()
            }, label: {
                UserImage()
            })
        )
    }
}

struct Photos_Previews: PreviewProvider {
    static var previews: some View {
        Photos()
            .previewLayout(.sizeThatFits)
            .previewDevice("iPhone 11")
            .preferredColorScheme(.light)
    }
}
