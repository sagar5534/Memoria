//
//  SwiftUIView.swift
//  
//
//  Created by Sagar R Patel on 2022-04-05.
//

import SwiftUI

struct AllPhotosView: View {
    let namespace: Namespace.ID

    @ObservedObject var photoGridData: PhotoGridData

    @State var selectedItem: Media? = nil
    @State private var scaler: CGFloat = 120
    var openModal: ((Media) -> Void)

    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: scaler), spacing: 2)]

        if photoGridData.isLoading {
            ProgressView().foregroundColor(.primary)
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(photoGridData.groupedMedia.indices, id: \.self) { i in
                        Section(header: titleHeader(header: photoGridData.groupedMedia[i].first!.creationDate.toDate()!.toString())) {
                            ForEach(photoGridData.groupedMedia[i].indices, id: \.self) { index in
                                ZStack {
                                    Color.clear
                                    if selectedItem?.id != photoGridData.groupedMedia[i][index].id {
                                        Thumbnail(item: photoGridData.groupedMedia[i][index])
                                            .onTapGesture {
                                                openModal(photoGridData.groupedMedia[i][index])
                                            }
                                            .scaledToFill()
                                            .layoutPriority(-1)
                                    }
                                }
                                .clipped()
                                .matchedGeometryEffect(id: photoGridData.groupedMedia[i][index].id, in: namespace)
                                .zIndex(selectedItem?.id == photoGridData.groupedMedia[i][index].id ? 100 : 1)
                                .aspectRatio(1, contentMode: .fit)
                                .id(photoGridData.groupedMedia[i][index].id)
                            }
                        }
                        .id(UUID())
                    }
                }
            }
        }
        
    }
}

private struct titleHeader: View {
    let header: String
    
    var body: some View {
        Text(header)
            .font(.custom("OpenSans-SemiBold", size: 14))
            .foregroundColor(.primary)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}


//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
////        SwiftUIView(namespace: , photoGridData: <#PhotoGridData#>, openModal: <#(Media) -> Void#>)
//    }
//}
