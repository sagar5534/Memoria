//
//  Photos.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SDWebImageSwiftUI
import SwiftUI

struct Photos: View {
    let columns = [
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
        GridItem(.flexible(), spacing: 4),
    ]

    @ObservedObject var model = NetworkManager.sharedInstance

    @State private var rectPosition: CGFloat = 0
    @State private var currentLevel = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ZStack(alignment: .topTrailing) {
                    List {
                        ForEach(model.data.indices, id: \.self) { i in
                            MonthView(monthwiseData: model.data[i])
                                .id(i)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .listStyle(PlainListStyle())

                    ScrollBarIcon()
                        .offset(x: 0, y: rectPosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let temp = checkScrollbarBoundry(value: value, geometry: geometry)
                                    self.rectPosition = temp
                                    moveScrollbar(temp: temp, proxy: proxy, geometry: geometry)
                                }
                        )
                }
            }
        }
    }

    private func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    private func checkScrollbarBoundry(value: DragGesture.Value, geometry: GeometryProxy) -> CGFloat {
        var temp = value.location.y
        if temp < 0 {
            temp = 0
        } else if value.location.y > (geometry.size.height - geometry.safeAreaInsets.bottom) {
            temp = (geometry.size.height - geometry.safeAreaInsets.bottom)
        }
        return temp
    }

    private func moveScrollbar(temp: CGFloat, proxy: ScrollViewProxy, geometry: GeometryProxy) {
        let fullheight = (geometry.size.height - geometry.safeAreaInsets.bottom)
        let eachStep = Int(Int(fullheight) / model.data.count)
        let level = Int(Int(temp) / eachStep)

        if currentLevel != level {
            currentLevel = level
//            withAnimation {
            proxy.scrollTo(level, anchor: .top)
//            }
            simpleSuccess()
        }
    }
}

private struct MonthView: View {
    let monthwiseData: Collection
    let curYear = Calendar.current.component(.year, from: Date())
    let month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    var body: some View {
        let tempYear = (monthwiseData.year == curYear) ? "" : ", \(String(monthwiseData.year))"
        let monthStr = month[monthwiseData.month]

        VStack(alignment: .leading) {
            Text("\(monthStr)\(tempYear)")
                .font(.title)
                .padding(.leading)
                .padding(.top, 50)

            ForEach(monthwiseData.data, id: \.self) { daywiseData in
                DayList(daywiseData: daywiseData)
            }
        }
    }
}

private struct DayList: View {
    let daywiseData: [Media]

    let columns =
        [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
        ]

    var body: some View {
        let date: Date = daywiseData.first!.creationDate.toDate()!

        VStack(alignment: .leading) {
            Text(date.toString())
                .font(.subheadline)
                .padding(.leading)
                .padding(.top, 5)
                .padding(.bottom, 5)

            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(daywiseData, id: \.self) { media in
                    PhotoView(media: media)
                }
            }
        }
    }
}

private struct PhotoView: View {
    var media: Media

    var body: some View {
        let path = (media.thumbnailPath.isEmpty ? media.path : media.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
        let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)

        WebImage(url: url!)
            .renderingMode(.original)
            .placeholder(content: { ProgressView() })
            .resizable()
            .scaledToFill()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
            .clipped()
    }
}

struct Photos_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Photos()
                .previewDevice("iPhone 11")
                .preferredColorScheme(.light)
                .modifier(InlineNavBar(title: "Memoria"))
        }
    }
}

//        .navigationTitle("Memoria")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarItems(trailing:
//            Button(action: {
////                model.upload()
//            }, label: {
//                UserImage()
//            })
//        )
