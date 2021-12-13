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
    var livePhotoUrl: URL?
    let isLivePhoto: Bool
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
            Text("Uploading")
        }
    }
}

class PhotosModel: ObservableObject {
    @Published var images: [UIImage] = []
    @Published var errorString: String = ""
    @ObservedObject var model = NetworkManager.sharedInstance
    var allImages = [FileUpload]()

    init() {
        getCameraRollAssets { assets in

            guard let assets = assets else { return }

            if assets.count > 0 {
                print(assets)
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

                    // Get all uploaded images fresh from server
                    // let uploadedAssets = NCManageDatabase.shared.getPhotoLibraryIdAsset(image: account.autoUploadImage, video: account.autoUploadVideo, account: account.account)
                    let uploadedAssets: [String]? = [""]

                    assets.enumerateObjects { asset, _, _ in
                        var creationDate = ""
                        var assetId = ""

                        if asset.creationDate != nil { creationDate = String(describing: asset.creationDate!) }
                        assetId = asset.localIdentifier + creationDate

                        // Check if already uploaded
                        if !(uploadedAssets?.contains(assetId) ?? false) {
                            pendingAssets.append(asset)
                        }
                    }
                    completion(pendingAssets)

                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }

//        let uploadQueue = DispatchQueue.global(qos: .userInitiated)
//        let uploadGroup = DispatchGroup()
//        let uploadSemaphore = DispatchSemaphore(value: 30)
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.includeAssetSourceTypes = .typeUserLibrary
//
//        uploadQueue.async(group: uploadGroup) { [weak self] in
//            guard let self = self else { return }
//
//            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//
//            for i in 0 ..< fetchResult.count {
//                uploadGroup.enter()
//                uploadSemaphore.wait()
//                self.getAssetDetails(asset: fetchResult.object(at: i)) {
//                    uploadGroup.leave()
//                    uploadSemaphore.signal()
//                }
//            }
//        }
//
//        uploadGroup.notify(queue: .main) {
//            print("Done Fetching")
//            self.uploadImages()
//        }
    }

    func getAssetDetails(asset: PHAsset, completion: @escaping () -> Void) {
        let semaphore = DispatchSemaphore(value: 0)

        let assetResources = PHAssetResource.assetResources(for: asset)

        var url: URL?
        var livePhotoUrl: URL?
        var isLivePhoto = false
        let creationDate = asset.creationDate ?? Date()
        let isFavorite = asset.isFavorite
        let assetId = asset.localIdentifier
        let filename = assetResources.first?.originalFilename
        let mimeType = UTTypeCopyPreferredTagWithClass(assetResources.first!.uniformTypeIdentifier as CFString, kUTTagClassMIMEType)!.takeRetainedValue()

        if asset.mediaSubtypes.contains(.photoLive) {
            isLivePhoto = true
            LivePhoto.extractResources(from: asset) { livePhotoResources in
                if livePhotoResources != nil {
                    let (pairedImage, pairedVideo) = livePhotoResources!
                    url = pairedImage
                    livePhotoUrl = pairedVideo
                } else {
                    completion()
                }
                semaphore.signal()
            }
        }

        semaphore.wait()

        let temp = FileUpload(
            url: url!,
            livePhotoUrl: livePhotoUrl!,
            isLivePhoto: isLivePhoto,
            assetId: assetId,
            filename: filename ?? "file",
            mimeType: mimeType as String,
            creationDate: creationDate,
            isFavorite: isFavorite
        )
        allImages.append(temp)

        completion()
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

    //    private func uploadAssetsNewAndFull(viewController: UIViewController?, selector: String, log _: String, completion: @escaping (_ items: Int) -> Void) {
    //        var counterLivePhoto: Int = 0
    //        //        var metadataFull: [tableMetadata] = []
    //        var counterItemsUpload: Int = 0
    //
    //        DispatchQueue.global(qos: .background).async { [self] in
    //
    //            self.getCameraRollAssets(viewController: viewController, selector: selector, alignPhotoLibrary: false) { assets in
    //
    //                if assets == nil || assets?.count == 0 {
    //                    DispatchQueue.main.async {
    //                        completion(counterItemsUpload)
    //                    }
    //                    return
    //                } else {
    //                    print("Automatic upload, new \(assets?.count ?? 0) assets found [\" + log + \"]\"")
    //                }
    //                guard let assets = assets else { return }
    //
    //                for asset in assets {
    //                    var livePhoto = false
    //                    var session: String = ""
    //                    guard let assetDate = asset.creationDate else { continue }
    //                    let assetMediaType = asset.mediaType
    //                    let formatter = DateFormatter()
    //                    var serverUrl: String = ""
    //
    //                    if asset.mediaSubtypes.contains(.photoLive) {
    //                        livePhoto = true
    //                    }
    //
    //                    session = NCCommunicationCommon.shared.sessionIdentifierUpload
    //                    session = "com.memoria.session.upload"
    //
    //                    formatter.dateFormat = "yyyy"
    //                    let yearString = formatter.string(from: assetDate)
    //                    formatter.dateFormat = "MM"
    //                    let monthString = formatter.string(from: assetDate)
    //
    //                    serverUrl = autoUploadPath // ?
    //
    //                    // MOST COMPATIBLE SEARCH --> HEIC --> JPG
    //                    var fileNameSearchMetadata = fileName
    //                    let ext = (fileNameSearchMetadata as NSString).pathExtension.uppercased()
    //                    if ext == "HEIC", CCUtility.getFormatCompatibility() {
    //                        fileNameSearchMetadata = (fileNameSearchMetadata as NSString).deletingPathExtension + ".jpg"
    //                    }
    //
    //                    /* INSERT METADATA FOR UPLOAD */
    //                    let metadataForUpload = createMetadata(account: account.account, user: account.user, userId: account.userId, fileName: fileName, fileNameView: fileName, ocId: NSUUID().uuidString, serverUrl: serverUrl, urlBase: account.urlBase, url: "", contentType: "", livePhoto: livePhoto)
    //
    //                    metadataForUpload.assetLocalIdentifier = asset.localIdentifier
    //                    metadataForUpload.session = session
    //                    metadataForUpload.sessionSelector = selector
    //                    metadataForUpload.size = NCUtilityFileSystem.shared.getFileSize(asset: asset)
    //                    metadataForUpload.status = NCGlobal.shared.metadataStatusWaitUpload
    //
    //                    if assetMediaType == PHAssetMediaType.video {
    //                        metadataForUpload.classFile = NCCommunicationCommon.typeClassFile.video.rawValue
    //                    } else if assetMediaType == PHAssetMediaType.image {
    //                        metadataForUpload.classFile = NCCommunicationCommon.typeClassFile.image.rawValue
    //                    }
    //
    //                    if selector == NCGlobal.shared.selectorUploadAutoUpload {
    //                        NCCommunicationCommon.shared.writeLog("Automatic upload added \(metadataForUpload.fileNameView) (\(metadataForUpload.size) bytes) with Identifier \(metadataForUpload.assetLocalIdentifier)")
    //                        self.appDelegate.networkingProcessUpload?.createProcessUploads(metadatas: [metadataForUpload], verifyAlreadyExists: true)
    //                        NCManageDatabase.shared.addPhotoLibrary([asset], account: account.account)
    //                    } else if selector == NCGlobal.shared.selectorUploadAutoUploadAll {
    //                        metadataFull.append(metadataForUpload)
    //                    }
    //                    counterItemsUpload += 1
    //
    //                    /* INSERT METADATA MOV LIVE PHOTO FOR UPLOAD */
    //                    if livePhoto {
    //                        counterLivePhoto += 1
    //                        let fileName = (fileName as NSString).deletingPathExtension + ".mov"
    //                        let ocId = NSUUID().uuidString
    //                        let filePath = CCUtility.getDirectoryProviderStorageOcId(ocId, fileNameView: fileName)!
    //
    //                        CCUtility.extractLivePhotoAsset(asset, filePath: filePath) { url in
    //                            if url != nil {
    //                                let metadataForUpload = NCManageDatabase.shared.createMetadata(account: account.account, user: account.user, userId: account.userId, fileName: fileName, fileNameView: fileName, ocId: ocId, serverUrl: serverUrl, urlBase: account.urlBase, url: "", contentType: "", livePhoto: livePhoto)
    //                                metadataForUpload.session = session
    //                                metadataForUpload.sessionSelector = selector
    //                                metadataForUpload.size = NCUtilityFileSystem.shared.getFileSize(filePath: filePath)
    //                                metadataForUpload.status = NCGlobal.shared.metadataStatusWaitUpload
    //                                metadataForUpload.classFile = NCCommunicationCommon.typeClassFile.video.rawValue
    //
    //                                if selector == NCGlobal.shared.selectorUploadAutoUpload {
    //                                    NCCommunicationCommon.shared.writeLog("Automatic upload added Live Photo \(metadataForUpload.fileNameView) (\(metadataForUpload.size) bytes) with Identifier \(metadataForUpload.assetLocalIdentifier)")
    //                                    self.appDelegate.networkingProcessUpload?.createProcessUploads(metadatas: [metadataForUpload], verifyAlreadyExists: true)
    //
    //                                } else if selector == NCGlobal.shared.selectorUploadAutoUploadAll {
    //                                    metadataFull.append(metadataForUpload)
    //                                }
    //                                counterItemsUpload += 1
    //                            }
    //                            counterLivePhoto -= 1
    //                            if counterLivePhoto == 0 && self.endForAssetToUpload {
    //                                DispatchQueue.main.async {
    //                                    if selector == NCGlobal.shared.selectorUploadAutoUploadAll {
    //                                        self.appDelegate.networkingProcessUpload?.createProcessUploads(metadatas: metadataFull)
    //                                    }
    //                                    completion(counterItemsUpload)
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //
    //                if counterLivePhoto == 0 {
    //                    DispatchQueue.main.async {
    //                        if selector == NCGlobal.shared.selectorUploadAutoUploadAll {
    //                            self.appDelegate.networkingProcessUpload?.createProcessUploads(metadatas: metadataFull)
    //                        }
    //                        completion(counterItemsUpload)
    //                    }
    //                }
    //            }
    //        }
    //    }

    func askAuthorizationPhotoLibrary(completion: @escaping (_ hasPermission: Bool) -> Void) {
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

    //    @objc fnc createMetadata(account: String, user: String, userId: String, fileName: String, fileNameView _: String, ocId: String, serverUrl: String, urlBase: String, url: String, contentType _: String, livePhoto: Bool) -> tableMetadata {
    //        let metadata = tableMetadata()
    //
    //        metadata.account = account
    //        metadata.chunk = false
    //        let mimeType = UTTypeCopyPreferredTagWithClass(data.first!.uniformTypeIdentifier as CFString, kUTTagClassMIMEType)!.takeRetainedValue()
    //
    //        metadata.contentType = resultInternalType.mimeType
    //        metadata.creationDate = Date() as NSDate
    //        metadata.date = Date() as NSDate
    //        metadata.hasPreview = true
    //        metadata.etag = ocId
    //        metadata.ext = (fileName as NSString).pathExtension.lowercased()
    //        metadata.fileName = fileName
    //        metadata.fileNameView = fileName
    //        metadata.fileNameWithoutExt = (fileName as NSString).deletingPathExtension
    //        metadata.livePhoto = livePhoto
    //        metadata.ocId = ocId
    //        metadata.permissions = "RGDNVW"
    //        metadata.serverUrl = serverUrl
    //        metadata.uploadDate = Date() as NSDate
    //        metadata.url = url
    //        metadata.urlBase = urlBase
    //        metadata.user = user
    //        metadata.userId = userId
    //
    //        return metadata
    //    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
