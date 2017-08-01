//
//  ImageCacheMain.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

/// Implementation imageCache protocol
class ImageCacheMain: ImageCache {
  static public let shared = ImageCacheMain()

    fileprivate let cache = NSCache<AnyObject, AnyObject>()
    fileprivate let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

    class func decodedImageWithImage(image: UIImage) -> UIImage? {
        guard let imageRef = image.cgImage else {
            return nil
        }
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
            .union(.byteOrder32Little)
        guard let context = CGContext(data: nil, width: imageRef.width,
                                      height: imageRef.height, bitsPerComponent: 8,
                                      bytesPerRow: imageRef.width * 4, space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
                                        return nil
        }
        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: imageRef.width, height: imageRef.height))
        context.draw(imageRef, in: rect)

        guard let decompressedImageRef = context.makeImage() else {
            return nil
        }
        let decompressedImage = UIImage.init(cgImage: decompressedImageRef)

        return decompressedImage
    }

    func decompressImage(compressedImage: UIImage, storeInCacheForKey key: String) -> UIImage? {
        guard let image = ImageCacheMain.decodedImageWithImage(image: compressedImage) else {
            return nil
        }
        cache.setObject(image, forKey: key as AnyObject)

        return image
    }

    func filePathForURLString(urlString: String) -> String? {
        guard let filname = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }

        return cachePath.appendingPathComponent(filname)
    }

    // MARK: ImageCache Protocol

    func decompressedImageFromMemoryCache(for url: URL) -> UIImage? {
        return cache.object(forKey: url.absoluteString as AnyObject) as? UIImage
    }

    func decompressedImageFromDiskCache(for url: URL) -> UIImage? {
        let urlString = url.absoluteString
        guard let path = self.filePathForURLString(urlString: urlString) else {
            return nil
        }
        if FileManager.default.fileExists(atPath: path) {

            if let data = FileManager.default.contents(atPath: path),
                let image = UIImage(data: data) {
                return self.decompressImage(compressedImage: image, storeInCacheForKey: urlString)
            }
        }
        return nil
    }

    func storeImageDataAndRetrunDecompressedImage(for data: Data, and url: URL) -> UIImage? {
        let urlString = url.absoluteString
        if let image = UIImage.init(data: data),
          let decompressedImage  = self.decompressImage(compressedImage: image, storeInCacheForKey: urlString),
          let path = self.filePathForURLString(urlString: urlString) {
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)

            return decompressedImage
        }
        return nil
    }
}
