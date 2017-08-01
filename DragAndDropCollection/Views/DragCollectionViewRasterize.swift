//
//  DragCollectionView+Rasterize.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

extension DragDropCollectionView {
    func getRasterizedImageCopyOfCell(_ cell: UICollectionViewCell) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
