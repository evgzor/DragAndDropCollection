//
//  ImageLoader.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

/// Load images with cache functionality
public class ImageLoader: Loader {
  let casheMain = ImageCacheMain()

  func loadImage(url: URL?, completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
    if  let url = url {
      Loader.queue.async {
        if let image = self.casheMain.decompressedImageFromDiskCache(for: url) {
          completionHandler(image, nil)
          return
        }
        Loader.fetcher.fetchBackgroudImage(for: url, completionHandler: { (data, url, error) in
          guard let fetchedData = data
            else {
            completionHandler(nil, error)
              return
          }
          if let image = self.casheMain.storeImageDataAndRetrunDecompressedImage(for: fetchedData, and: url) {
            completionHandler(image, nil)
          } else {
            completionHandler(nil, NSError(domain:"The data is not an image", code:1, userInfo:nil))
          }
        })
      }
    }
  }
}
