//
//  ViewController+UICollectionViewDelegateFlowLayout.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

/// Implemetation custom layout with special cell order
class DraggableLayout: UICollectionViewFlowLayout {

    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    fileprivate var contentHeight: CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat = 0.0

    let basicOffset: CGFloat = 5.0

   public  func size(at indexPath: IndexPath) -> CGSize {

    guard let size = collectionView?.bounds.size else {
      return .zero
    }
        if indexPath.row == 0 {
            return CGSize.init(width: basicOffset + 2*(size.width - CGFloat(4 * basicOffset))/3,
                               height: basicOffset + 2*(size.width - CGFloat(4 * basicOffset))/3)
        } else {
            return CGSize.init(width: (size.width - CGFloat(4 * basicOffset))/3,
                               height: (size.width - CGFloat(4 * basicOffset))/3)
        }
    }

    override func prepare() {
        self.scrollDirection = .vertical
        if cache.isEmpty {
            guard  let numItems = collectionView?.numberOfItems(inSection: 0), numItems > 0 else {
                return
            }
            let itemWidth = self.size(at: IndexPath(row: 1, section: 0)).width
            let startOffsetX = 2.0*(itemWidth + basicOffset) + basicOffset
            var startOffsetBufX = startOffsetX
            let startOffsetY = self.size(at: IndexPath.init(row: 0, section: 0)).width + 2*basicOffset
            var startOffsetBufY = startOffsetY
            var isGoToLeft = true
            for index in 0 ... numItems - 1 {
                let indexPath = IndexPath(item: index, section: 0)
                let size = self.size(at: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                var xOffset: CGFloat = basicOffset
                var yOffset: CGFloat = basicOffset
                switch index {
                case 0:
                    let frame = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
                    attributes.frame = frame
                    cache.append(attributes)
                    break
                case 1...2:
                    xOffset = self.size(at: IndexPath(row: 0, section: 0)).width + 2 * basicOffset
                    yOffset = CGFloat(index - 1) * size.height + basicOffset * CGFloat(index)
                    let frame = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
                    attributes.frame = frame
                    cache.append(attributes)
                    break
                default:
                    yOffset = startOffsetBufY
                    xOffset = startOffsetBufX
                    if index % 3 == 0 {
                        let multiplier: CGFloat = isGoToLeft ? -1 : 1
                        isGoToLeft = !isGoToLeft
                        for i in 0 ... 2 {
                            if index + Int(i) > numItems - 1 {
                                break
                            }
                            let indexPath = IndexPath(item: index + i, section: 0)
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                            let frame = CGRect(x: xOffset, y: yOffset, width: size.width, height: size.height)
                            attributes.frame = frame
                            cache.append(attributes)
                            xOffset = startOffsetBufX + multiplier * (itemWidth +  basicOffset)
                            startOffsetBufX  = xOffset
                        }
                        startOffsetBufY +=  itemWidth + basicOffset
                        yOffset = startOffsetBufY
                        startOffsetBufX = isGoToLeft ? startOffsetX : basicOffset
                    }
                    break
                }
            }
            contentWidth = self.collectionView?.bounds.size.width ?? 0.0
            contentHeight = startOffsetBufY
        }
    }

    override func invalidateLayout() {
        cache.removeAll()
        super.invalidateLayout()
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
  }
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        // Loop through the cache and look for items in the rect
        for attributes  in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

}
