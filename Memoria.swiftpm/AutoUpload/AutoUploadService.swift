//
//  AutoUploadService.swift
//  Memoria
//
//  Created by Sagar Patel on 2021-08-07.
//

import Combine
import MobileCoreServices
import Photos
import SwiftUI

class AutoUploadService: ObservableObject {
    static let sharedInstance = AutoUploadService()
    private var service = Service.shared
    private var cancellableSet: Set<AnyCancellable> = []
    private var serviceIsRunning = false

    @Published var isUploading: Bool = false
    @Published var currentFileUpload: FileUpload? = nil
    @Published var UploadedCount = 0.0
    @Published var ToUploadCount = 0.0
    

    @AppStorage("backupEnabled") private var backupEnabled = false
    @AppStorage("cellularBackup") private var cellularBackup = false

    func initiateAutoUpload(onComplete: @escaping () -> Void) {
        guard !serviceIsRunning, backupEnabled else { return }
        // TODO: Check if on cellular and allowed

        serviceIsRunning = true

        askAuthorizationPhotoLibrary { hasPermission in
            if hasPermission {
                self.createUploadList { uploadList in
                    guard uploadList != nil, uploadList!.count > 0 else {
                        self.serviceIsRunning = false
                        return
                    }
                    self.ToUploadCount = Double(uploadList!.count)

                    withAnimation {
                        self.isUploading = true
                    }

                    let uploadQueue = DispatchQueue.global(qos: .default)
                    let uploadGroup = DispatchGroup()
                    let uploadSemaphore = DispatchSemaphore(value: 1)

                    uploadQueue.async(group: uploadGroup) { [weak self] in
                        guard let self = self else { return }

                        for file in uploadList! {
                            uploadGroup.enter()
                            uploadSemaphore.wait()

                            // Do this code in main thread
                            DispatchQueue.main.async {
                                withAnimation {
                                    self.currentFileUpload = file
                                }
                            }

                            self.service.uploadMedia(file: file)
                                .sink { dataResponse in
                                    if dataResponse.error != nil {
                                        print("Upload Error", dataResponse.error)
                                    }
                                    withAnimation {
                                        self.UploadedCount += 1
                                    }
                                    uploadGroup.leave()
                                    uploadSemaphore.signal()
                                }
                                .store(in: &self.cancellableSet)
                        }
                    }

                    uploadGroup.notify(queue: .main) {
                        print("Upload Completed")
                        withAnimation {
                            self.isUploading = false
                        }
                        onComplete()
                        self.UploadedCount = 0
                        self.ToUploadCount = 0
                        self.currentFileUpload = nil
                        self.serviceIsRunning = false
                    }
                }
            } else {
                self.backupEnabled = false
                self.serviceIsRunning = false
            }
        }
    }

    private func createUploadList(completion: @escaping (_ uploadList: [FileUpload]?) -> Void) {
        getCameraRollAssets { assets in

            if assets == nil {
                print("Automatic upload: Assets Error")
            } else if assets!.count == 0 {
                DispatchQueue.main.async {
                    print("Automatic upload: no new assets found")
                    completion([])
                }
            } else {
                print("Automatic upload: \(assets?.count ?? 0) new assets found")
            }

            guard let assets = assets else { return }

            let myGroup = DispatchGroup()
            var uploadList: [FileUpload] = []

            for asset in assets {
                myGroup.enter()

                let assetResources = PHAssetResource.assetResources(for: asset)
                var fileUpload = self.createFileUpload()

                let filename = ((assetResources.first?.originalFilename ?? "File") as NSString)
                    .deletingPathExtension
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "File"
                let creationDate = asset.creationDate ?? Date()
                let modificationDate = asset.modificationDate ?? creationDate

                fileUpload.assetId = asset.localIdentifier
                fileUpload.filename = filename
                fileUpload.mediaType = asset.mediaType.rawValue
                fileUpload.mediaSubType = Int(asset.mediaSubtypes.rawValue)
                fileUpload.creationDate = creationDate
                fileUpload.modificationDate = modificationDate
                fileUpload.duration = asset.duration
                fileUpload.isFavorite = asset.isFavorite
                fileUpload.isHidden = asset.isHidden

                switch asset.mediaType {
                case .video:

                    asset.getURL { assetURL in
                        if assetURL != nil {
                            fileUpload.url = assetURL
                            uploadList.append(fileUpload)
                        } else {
                            print("Automatic upload: Failed to extract resource from Video", asset)
                        }
                        myGroup.leave()
                    }

                case .image:

                    if asset.mediaSubtypes.contains(.photoLive) {
                        fileUpload.isLivePhoto = true
                        LivePhoto.extractResources(from: asset) { livePhotoResources in
                            if livePhotoResources != nil {
                                let (pairedImage, pairedVideo) = livePhotoResources!
                                fileUpload.url = pairedImage
                                fileUpload.livePhotoUrl = pairedVideo
                                uploadList.append(fileUpload)
                            } else {
                                print("Failed to extract resource from LivePhoto", asset)
                            }
                            myGroup.leave()
                        }
                    } else {
                        asset.getURL { url in
                            if url != nil {
                                fileUpload.url = url
                                uploadList.append(fileUpload)
                            } else {
                                print("Failed to extract resource from Photo", asset)
                            }
                            myGroup.leave()
                        }
                    }

                default:
                    print("Asset does not identify as Video or Image", asset)
                    myGroup.leave()
                }
            }

            myGroup.notify(queue: .main) {
                completion(uploadList)
            }
        }
    }

    private func getCameraRollAssets(completion: @escaping (_ assets: [PHAsset]?) -> Void) {
        askAuthorizationPhotoLibrary { hasPermission in

            if hasPermission {
                let assetCollection = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
                if assetCollection.count > 0 {
                    let predicateImage = NSPredicate(format: "mediaType == %i", PHAssetMediaType.image.rawValue)
                    let predicateVideo = NSPredicate(format: "mediaType == %i", PHAssetMediaType.video.rawValue)
                    var predicate: NSPredicate?
                    predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateImage, predicateVideo])
                    let fetchOptions = PHFetchOptions()
                    fetchOptions.predicate = predicate

                    var pendingAssets: [PHAsset] = []
                    let assets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(in: assetCollection.firstObject!, options: fetchOptions)

                    self.service.fetchAllAssetId()
                        .sink { dataResponse in
                            guard dataResponse.value != nil else {
                                completion(pendingAssets)
                                return
                            }
                            print("Fetched Asset Ids", dataResponse.value!.count, "Items")

                            let uploadedAssets = dataResponse.value
                            assets.enumerateObjects { asset, _, _ in
                                if !(uploadedAssets?.contains(asset.localIdentifier) ?? false) {
                                    pendingAssets.append(asset)
                                }
                            }
                            completion(pendingAssets)
                        }
                        .store(in: &self.cancellableSet)

                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }

    private func askAuthorizationPhotoLibrary(completion: @escaping (_ hasPermission: Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case PHAuthorizationStatus.authorized, PHAuthorizationStatus.limited:
            completion(true)
        case PHAuthorizationStatus.denied, PHAuthorizationStatus.restricted:
            completion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization { allowed in
                DispatchQueue.main.async {
                    if allowed == PHAuthorizationStatus.authorized {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        default:
            completion(false)
        }
    }

    private func createFileUpload() -> FileUpload {
        return FileUpload(
            assetId: UUID().uuidString,
            filename: "File",
            mediaType: PHAssetMediaType.unknown.rawValue,
            mediaSubType: -1,
            creationDate: Date(),
            modificationDate: Date(),
            duration: 0,
            isFavorite: false,
            isHidden: false,
            isLivePhoto: false,
            source: .ios
        )
    }
}
