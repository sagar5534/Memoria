//
//  Library.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import Alamofire
import Combine
import MobileCoreServices
import Photos
import SwiftUI

struct FileUpload {
    let url: URL
    let assetId: String
    let filename: String
    let mimeType: String
    let creationDate: Date
    let isFavorite: Bool
}

struct Library: View {
    @ObservedObject var photos = PhotosModel()
    @ObservedObject var model = NetworkManager.sharedInstance

    var body: some View {
        VStack {
            List(photos.images, id: \.self) { photo in
                Image(uiImage: photo)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

class PhotosModel: ObservableObject {
    @Published var images: [UIImage] = []
    @Published var errorString: String = ""
    @ObservedObject var model = NetworkManager.sharedInstance
    var allImages = [FileUpload]()

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

    private func getAllPhotos() {
        let uploadQueue = DispatchQueue.global(qos: .userInitiated)
        let uploadGroup = DispatchGroup()
        let uploadSemaphore = DispatchSemaphore(value: 30)

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.includeAssetSourceTypes = .typeUserLibrary

        uploadQueue.async(group: uploadGroup) { [weak self] in
            guard let self = self else { return }

            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            for i in 0 ..< fetchResult.count {
                uploadGroup.enter()
                uploadSemaphore.wait()
                self.getAssetDetails(asset: fetchResult.object(at: i)) {
                    uploadGroup.leave()
                    uploadSemaphore.signal()
                }
            }
        }

        uploadGroup.notify(queue: .main) {
            print("Done Fetching")
            self.uploadImages()
        }
    }

    func getAssetDetails(asset: PHAsset, completionHandler: @escaping () -> Void) {
        let data = PHAssetResource.assetResources(for: asset)
        let creationDate = asset.creationDate ?? Date()
        let isFavorite = asset.isFavorite
        let assetId = asset.localIdentifier
        let filename = data.first?.originalFilename
        let mimeType = UTTypeCopyPreferredTagWithClass(data.first!.uniformTypeIdentifier as CFString, kUTTagClassMIMEType)!.takeRetainedValue()

        asset.getURL { u in
            if u != nil {
                self.allImages.append(FileUpload(
                    url: u!,
                    assetId: assetId,
                    filename: filename ?? "file",
                    mimeType: mimeType as String,
                    creationDate: creationDate,
                    isFavorite: isFavorite
                )
                )
            }
            completionHandler()
        }
    }

    private func uploadImages() {
        let uploadQueue = DispatchQueue.global(qos: .userInitiated)
        let uploadGroup = DispatchGroup()
        let uploadSemaphore = DispatchSemaphore(value: 30)

        uploadQueue.async(group: uploadGroup) { [weak self] in
            guard let self = self else { return }

            for (_, file) in self.allImages.enumerated() {
                uploadGroup.enter()
                uploadSemaphore.wait()
                NetworkManager.sharedInstance.upload(file: file) {
                    uploadGroup.leave()
                    uploadSemaphore.signal()
                }
            }
        }

        uploadGroup.notify(queue: .main) {
            print("Done Uploading")
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
