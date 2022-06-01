//
//  AutoUploadProgress.swift
//
//
//  Created by Sagar R Patel on 2022-05-15.
//

import SwiftUI

struct AutoUploadProgress: View {
    @EnvironmentObject var autoUploadService: AutoUploadService

    var body: some View {
        if autoUploadService.isUploading {
            VStack(alignment: .leading, spacing: 0) {

                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Backing Up...")
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("\(Int(autoUploadService.ToUploadCount - autoUploadService.UploadedCount)) Items left")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()

                    if autoUploadService.currentFileUpload != nil {
                        AsyncImage(
                            url: autoUploadService.currentFileUpload?.url
                        ) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: .infinity)
                                .border(.red, width: 2)
                        } placeholder: { Color.clear }
                    }
                }
                .frame(height: 50)
                .padding(.horizontal)
                .padding(.vertical, 8)

                ProgressView(value: autoUploadService.UploadedCount, total: autoUploadService.ToUploadCount)
                    .progressViewStyle(.linear)
            }
            .transition(.move(edge: .top))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AutoUploadProgress()
            .environmentObject({ () -> AutoUploadService in
                let env = AutoUploadService()
                env.isUploading = true
                env.currentFileUpload = FileUpload(url: URL(fileURLWithPath: "Users/patelsag/Library/Developer/CoreSimulator/Devices/2C95F8B3-D8AB-407F-AC61-38887E61E008/data/Media/DCIM/100APPLE/IMG_0010.PNG"), assetId: "", filename: "", mediaType: 1, mediaSubType: 1, creationDate: Date(), modificationDate: Date(), duration: 0, isFavorite: true, isHidden: true, isLivePhoto: true, source: .ios)
                return env
            }())
            .previewLayout(.sizeThatFits)
            .previewDisplayName("Auto Upload")
    }
}
