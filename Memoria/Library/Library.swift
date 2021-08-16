//
//  Library.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import MobileCoreServices
import Photos
import SwiftUI

struct Library: View {
    @ObservedObject var photos = PhotosModel()
    @ObservedObject var model = NetworkManager.sharedInstance

    var body: some View {
        VStack {
            List(photos.allUrls, id: \.self) { photo in
                let imageData = NSData(contentsOf: photo)!

                Image(uiImage: UIImage(data: imageData as Data) ?? UIImage())
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

class PhotosModel: ObservableObject {
    @Published var allUrls = [URL]()
    @Published var errorString: String = ""
    @ObservedObject var model = NetworkManager.sharedInstance

    init() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.errorString = ""
                self.getAllPhotos()
            case .denied, .restricted:
                self.errorString = "Photo access permission denied"
            case .notDetermined:
                self.errorString = "Photo access permission not determined"
            case .limited:
                self.errorString = "Photo access limited"
            @unknown default:
                fatalError()
            }
        }
    }

    fileprivate func getAllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary
        

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if results.count > 0 {
            for i in 0 ..< results.count {
                let asset = results.object(at: i)

                let data = PHAssetResource.assetResources(for: asset)
                let filename = data.first?.originalFilename
                let fileExtension = UTTypeCopyPreferredTagWithClass(data.first!.uniformTypeIdentifier as CFString, kUTTagClassMIMEType)!.takeRetainedValue()
                
                asset.getURL { u in
                    self.model.upload(url: u!, fileName: filename ?? "file", mimeType: fileExtension as String)
                }

            }
        } else {
            errorString = "No photos to display"
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
