//
//  Photos.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SDWebImageSwiftUI
import SwiftUI

struct PhotoGrid: View {
    @ObservedObject var photoGridData = PhotoGridData()

    var onThumbnailTap: (_ item: Media, _ geometry: GeometryProxy) -> Void = { _, _ in }
//    var namespace: Namespace.ID
    
    var body: some View {
        
        List {
            ForEach(photoGridData.allMedia.indices, id: \.self) { i in
                Text(photoGridData.allMedia[i].creationDate)
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        
    }
}

struct Photos_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
//            PhotoGrid(namespace: Namespace().wrappedValue)
            PhotoGrid()
                .previewDevice("iPhone 11")
                .preferredColorScheme(.light)
                .modifier(InlineNavBar(title: "Memoria"))
        }
    }
}









//    var body: some View {
//        GeometryReader { _ in
//            ScrollViewReader { _ in
//                List {
//                    ForEach(photoGridData.allMedia.indices, id: \.self) { i in
//                        MonthView(onThumbnailTap: onThumbnailTap, namespace: namespace, monthwiseData: model.data[i])
//                            .id(i)
//                    }
//                    .listRowInsets(EdgeInsets())
//                }
//                .listStyle(PlainListStyle())
//            }
//        }
//    }
//}
//
//private struct MonthView: View {
//    var onThumbnailTap: (_ item: Media, _ geometry: GeometryProxy) -> Void
//    var namespace: Namespace.ID
//
//    let monthwiseData: Collection
//    let curYear = Calendar.current.component(.year, from: Date())
//    let month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
//
//    var body: some View {
//        let tempYear = (monthwiseData.year == curYear) ? "" : ", \(String(monthwiseData.year))"
//        let monthStr = month[monthwiseData.month]
//
//        VStack(alignment: .leading) {
//            Text("\(monthStr)\(tempYear)")
//                .font(.title)
//                .padding(.leading)
//                .padding(.top, 50)
//
//            ForEach(monthwiseData.data, id: \.self) { daywiseData in
//                DayList(daywiseData: daywiseData, onThumbnailTap: onThumbnailTap, namespace: namespace)
//            }
//        }
//    }
//}
//
//private struct DayList: View {
//    @EnvironmentObject var currentlySelected: CurrentlySelected
//
//    let daywiseData: [Media]
//    var onThumbnailTap: (_ item: Media, _ geometry: GeometryProxy) -> Void
//    var namespace: Namespace.ID
//
//    let columns =
//        [
//            GridItem(.flexible(), spacing: 4),
//            GridItem(.flexible(), spacing: 4),
//            GridItem(.flexible(), spacing: 4),
//        ]
//
//    var body: some View {
//        let date: Date = daywiseData.first!.creationDate.toDate()!
//
//        VStack(alignment: .leading) {
//            Text(date.toString())
//                .font(.subheadline)
//                .padding(.leading)
//                .padding(.top, 5)
//                .padding(.bottom, 5)
//
//            LazyVGrid(columns: columns, spacing: 4) {
//                ForEach(daywiseData, id: \.self) { media in
//                    if media != currentlySelected.media {
//                        GeometryReader { geometry in
//                            Thumbnail(item: media)
//                                .onTapGesture { onThumbnailTap(media, geometry) }
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 130, maxHeight: .infinity, alignment: .center)
//                        .matchedGeometryEffect(id: media.path, in: namespace)
//                        .transition(.invisible)
//                    } else {
//                        Color.clear
//                    }
//                }
//            }
//        }
//    }
//}
