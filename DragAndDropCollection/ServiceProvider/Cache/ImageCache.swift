//
//  ImageCache.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

/// Comress decompress image data from disk and memory
protocol ImageCache {
  /// <#Description#>
  ///
  /// - Parameter url: image url
  /// - Returns: decompressed image
  func decompressedImageFromMemoryCache(for url: URL) -> UIImage?
  /// <#Description#>
  ///
  /// - Parameter url: image url
  /// - Returns: decompressed image from fisk
  func decompressedImageFromDiskCache(for url: URL) -> UIImage?
  /// <#Description#>
  ///
  /// - Parameters:
  ///   - data: store data
  ///   - url: data ule
  /// - Returns: stored image
  func storeImageDataAndRetrunDecompressedImage(for data: Data, and url: URL) -> UIImage?
}
