//
//  CombinedPhotos.swift
//  Memoria
//
//  Created by Sagar on 2021-08-19.
//

import SDWebImageSwiftUI
import SwiftUI
import Combine


struct CombinedPhotos: View {
    @Namespace var nspace

    // Photos
    @ObservedObject var model = NetworkManager.sharedInstance
    @State private var rectPosition: CGFloat = 0
    @State private var currentLevel = 0

    // Month
    let curYear = Calendar.current.component(.year, from: Date())
    let month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    // Day
    let columns =
        [
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
            GridItem(.flexible(), spacing: 4),
        ]
    
    //New
    @Environment(\.colorScheme) var scheme
    @State private var blur = false
    @State private var selectedItem: Media? = nil
    @State private var scrollUp = PassthroughSubject<Void, Never>()


    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in

                ZStack {
                    ZStack(alignment: .topTrailing) {
                        List {
                            ForEach(model.data.indices, id: \.self) { i in
                                let monthwiseData = model.data[i]
                                let tempYear = (monthwiseData.year == curYear) ? "" : ", \(String(monthwiseData.year))"
                                let monthStr = month[monthwiseData.month]

                                VStack(alignment: .leading) {
                                    Text("\(monthStr)\(tempYear)")
                                        .font(.title)
                                        .padding(.leading)
                                        .padding(.top, 50)

                                    ForEach(monthwiseData.data, id: \.self) { daywiseData in

                                        let date: Date = daywiseData.first!.creationDate.toDate()!

                                        VStack(alignment: .leading) {
                                            Text(date.toString())
                                                .font(.subheadline)
                                                .padding(.leading)
                                                .padding(.top, 5)
                                                .padding(.bottom, 5)

                                            LazyVGrid(columns: columns, spacing: 4) {
                                                ForEach(daywiseData, id: \.self) { media in
                                                    
                                                    if media.id != self.selectedItem?.id {
//                                                        Thumbnail(item: item)
                                                        WebImage(url: url!)
                                                            .renderingMode(.original)
                                                            .placeholder(content: { ProgressView() })
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
                                                            .clipped()
                                                            
                                                            .onTapGesture { tapThumbnail(media) }
                                                            .matchedGeometryEffect(id: media.id, in: nspace, properties: .frame)
                                                            .transition(.invisible)
                                                         
                                                    } else {
                                                        Color.clear.frame(width: config.thumbnailSize.width, height: config.thumbnailSize.height)
                                                    }
                                                    
                                                    
                                                    let path = (media.thumbnailPath.isEmpty ? media.path : media.thumbnailPath).replacingOccurrences(of: "\\", with: #"/"#)
                                                    let url = URL(string: #"http://192.168.100.107:3000/data/\#(path)"#)

                                                }
                                            }
                                        }
                                    }
                                }
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
                    .zIndex(1)
                    
                    // --------------------------------------------------------
                    // Backdrop to blur the grid while the modal is displayed
                    // --------------------------------------------------------
                    if blur {
                        VisualEffectView(uiVisualEffect: UIBlurEffect(style: scheme == .dark ? .dark : .light))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture(perform: tapBackdrop)
                            .transition(.opacity)
                            .zIndex(2)
                    }
                    
                    // --------------------------------------------------------
                    // Modal view
                    // --------------------------------------------------------
                    if self.selectedItem != nil {
                        Color.clear.overlay(
                            ModalView(item: self.selectedItem!, onCloseTap: tapBackdrop, scrollUp: scrollUp)
                                .matchedGeometryEffect(id: self.selectedItem!.id, in: nspace, properties: .position)
                        )
                        .zIndex(3)
                        .transition(.modal)
                    }
                    

                }
            }
        }
    }

    
    func tapBackdrop() {
        withAnimation(.blur) { self.blur = false }
        
        DispatchQueue.main.async {
            withAnimation(.hero) { self.selectedItem = nil }
            scrollUp.send()
        }
    }
    
    /// Blur the screen and open a modal on top.
    func tapThumbnail(_ item: Media) {
        withAnimation(.hero) { self.selectedItem = item }
        
        DispatchQueue.main.async {
            withAnimation(.blur) { self.blur = true }
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

struct CombinedPhotos_Previews: PreviewProvider {
    static var previews: some View {
        CombinedPhotos()
    }
}
