//
//  Extensions.swift
//  Memoria
//
//  Created by Sagar on 2021-08-08.
//

import Foundation
import Photos

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }
}

extension Date {
    func toString(withFormat format: String = "EE, MMM d") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}

// Delete after upload is done, Needs testing
extension PHAsset {
    func getURL(completionHandler: @escaping ((_ responseURL: URL?) -> Void)) {
        if mediaType == .image {
            let options = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = { (_: PHAdjustmentData) -> Bool in
                true
            }
            requestContentEditingInput(with: options, completionHandler: { (contentEditingInput: PHContentEditingInput?, _: [AnyHashable: Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: { (asset: AVAsset?, _: AVAudioMix?, _: [AnyHashable: Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
