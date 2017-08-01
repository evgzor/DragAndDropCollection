//
//  BasicCell.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 12/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

public class BasicCell: UICollectionViewCell {

  @IBOutlet fileprivate weak var imageView: UIImageView!

  /// please choose cached and not cached solutions
  let isUseCash = false

  public override func prepareForReuse() {
    super.prepareForReuse()
    imageView?.image = UIImage.init(named: "placeholder")

  }

  var imageURL: URL? {
    didSet {
      imageView?.image = UIImage.init(named: "placeholder")
      updateUI()
    }
  }

  func applyMode(model: ItemModel) {
    if let imageUrlString = model.imageUrlString {
      self.imageURL = URL.init(string: imageUrlString)
    }

  }

  private func updateUI() {
    if let url = imageURL {
      // Cached and not cashed solution
      if isUseCash {
        ImageLoader().loadImage(url: url, completionHandler: { image, _ in
          if let loadedImage = image {

            DispatchQueue.main.async {
              if url == self.imageURL {
                self.imageView?.image = loadedImage
              }
            }
          }
        })

      } else {
        DispatchQueue.global(qos: .userInitiated).async {
          let contentsOfURL = try? Data(contentsOf: url)
          DispatchQueue.main.async {
            if url == self.imageURL {
              if let imageData = contentsOfURL {
                self.imageView?.image = UIImage(data: imageData)
              }

            }
          }
        }
      }
    }
  }

}
