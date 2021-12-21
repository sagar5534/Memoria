//
//  AutoUploadService.swift
//  Memoria
//
//  Created by Sagar Patel on 2021-08-07.
//

import MobileCoreServices
import Photos
import SwiftUI

class AutoUploadService: ObservableObject {
    static let sharedInstance = AutoUploadService()

    @Published var uploadList: [FileUpload] = []
    @AppStorage("autoUpload") private var autoUpload = true

    private var running: Bool = false

    func initiateAutoUpload(completion: @escaping (_ items: Int) -> Void) {
        // TODO: Perhaps find a better way to make this safe??
        if running {
            print("Automatic upload: Already Running")
            return
        }
        running = true

        if autoUpload {
            askAuthorizationPhotoLibrary { hasPermission in
                if hasPermission {
                    self.createUploadList { uploadList in
                        guard uploadList != nil else { return }

                        if uploadList!.count > 0 {
                            MNetworking.sharedInstance.upload(uploadList: uploadList!) {
                                print("Starting")
                            } completion: { _, _ in
                                print("Uploading Finished")
                                self.running = false
                                completion(uploadList!.count)
                            }
                        } else {
                            completion(0)
                        }
                    }
                } else {
                    self.autoUpload = false
                    self.running = false
                    completion(0)
                }
            }
        } else {
            running.toggle()
            completion(0)
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

                fileUpload.assetId = asset.localIdentifier
                fileUpload.filename = ((assetResources.first?.originalFilename ?? "File") as NSString).deletingPathExtension
                fileUpload.mediaType = asset.mediaType.rawValue
                fileUpload.mediaSubType = Int(asset.mediaSubtypes.rawValue)
                fileUpload.creationDate = asset.creationDate ?? Date()
                fileUpload.modificationDate = asset.modificationDate ?? fileUpload.creationDate
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

                    MNetworking.sharedInstance.downloadSavedAssets {
                        // Start
                    } completion: { uploadedAssets, _, _ in
                        guard uploadedAssets != nil else {
                            completion(pendingAssets)
                            return
                        }
                        let uploadedAssets = uploadedAssets
                        assets.enumerateObjects { asset, _, _ in
                            if !(uploadedAssets?.contains(asset.localIdentifier) ?? false) {
                                pendingAssets.append(asset)
                            }
                        }
                        completion(pendingAssets)
                    }

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
            isLivePhoto: false
        )
    }
}
