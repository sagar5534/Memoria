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
    @AppStorage("backupEnabled") private var backupEnabled = false
//    @AppStorage("cellularBackup") private var cellularBackup = false

    private var uploadList: [FileUpload] = []
    @Published var running: Bool = false

    func initiateAutoUpload(onComplete: @escaping () -> Void) {
        if running {
            print("Automatic Upload: Already Running")
            return
        }
        running = true

        guard backupEnabled else {
            running = false
            return
        }

        // TODO: Check if on cellular and allowed

        if backupEnabled {
            askAuthorizationPhotoLibrary { hasPermission in
                if hasPermission {
                    self.createUploadList { uploadList in
                        guard uploadList != nil, uploadList!.count > 0 else {
                            self.running = false
                            return
                        }
                        MNetworking.sharedInstance.upload(uploadList: uploadList!) { success, failed in
                            print("Uploading Finished:", success, "Uploaded /", failed, "Failed")
                            self.running = false
                            onComplete()
                        }
                    }
                } else {
                    self.backupEnabled = false
                    self.running = false
                }
            }
        } else {
            running = false
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

                var filename = ((assetResources.first?.originalFilename ?? "File") as NSString).deletingPathExtension
                filename = filename.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "File"

                fileUpload.assetId = asset.localIdentifier
                fileUpload.filename = filename
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
                    } completion: { uploadedAssets, errorCode, errorDesc in
                                                
                        guard uploadedAssets != nil else {
                            print("Download Saved Assets Error: ", errorCode, errorDesc)
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
