//
//  Library.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import Alamofire
import MobileCoreServices
import Photos
import SwiftUI

struct FileUpload {
    let url: URL
    let filename: String
    let mimeType: String
    let creationDate: Date
}

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

//    func imageAndMetadataFromImageData(data: NSData)-> (UIImage?,[String: Any]?) {
//        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
//        if let imgSrc = CGImageSourceCreateWithData(data, options as CFDictionary) {
//            let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as! [String: Any]
//            //print(metadata)
//            // let image = UIImage(cgImage: imgSrc as! CGImage)
//            let image = UIImage(data: data as Data)
//            return (image, metadata)
//        }
//        return (nil, nil)
//    }

    fileprivate func getAllPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary

        let results: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        if results.count > 0 {
            var allFiles = [FileUpload]()

            // Get Files
            for i in 0 ..< results.count {
                let asset = results.object(at: i)
                let data = PHAssetResource.assetResources(for: asset)

                let creationDate = asset.creationDate ?? Date()
                let filename = data.first?.originalFilename
                let mimeType = UTTypeCopyPreferredTagWithClass(data.first!.uniformTypeIdentifier as CFString, kUTTagClassMIMEType)!.takeRetainedValue()

                asset.getURL { u in
                    if u != nil {
                        allFiles.append(FileUpload(url: u!, filename: filename ?? "file", mimeType: mimeType as String, creationDate: creationDate))
                    }
                }
            }

            let start = DispatchTime.now()
            let group = DispatchGroup()

            // Upload
            for file in allFiles {
                group.enter()

//                let parameters: [String: String] = [
//                    "creationDate": String(file.creationDate.timeIntervalSince1970),
//                    "user": "610cc064a35f2243803ab48c",
//                ]

//                AF.upload(multipartFormData: { multipartFormData in
//                    for (key, value) in parameters {
//                        multipartFormData.append(value.data(using: .utf8)!, withName: key)
//                    }
//                    multipartFormData.append(file.url, withName: "file", fileName: file.filename, mimeType: file.mimeType)
//                }, to: "http://192.168.100.107:3000/media/upload")
//
//                    .uploadProgress { progress in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                    }
//                    .responseJSON { _ in
//                        group.leave()
//                    }
            }

            group.notify(queue: DispatchQueue.global()) {
                print("Done Uploading")
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000

                print("Time to upload: \(timeInterval) seconds")
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
