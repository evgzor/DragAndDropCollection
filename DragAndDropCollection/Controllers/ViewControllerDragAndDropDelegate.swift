//
//  ViewControllerDragAndDropDelegate.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 15/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: DrapDropCollectionViewDelegate {
  func dragDropCollectionViewDidMoveCell(_ initialIndexPath: IndexPath, toNewIndexPath newIndexPath: IndexPath) {
    let itemsToMove = items[initialIndexPath.row]
    items.insert(itemsToMove, at: newIndexPath.row)
    items.remove(at: initialIndexPath.row)
  }
  func dragDropCollectionViewDraggingDidBeginWithCell(_ indexPath: IndexPath) {
    if indexPath == self.lastIndexPath() {
      self.dragDropCollectionView.enableDragging(false)
    } else {
      isDraggingCelll = true
    }
  }
  func dragDropCollectionViewDraggingDidEndForCell(_ indexPath: IndexPath) {
    isDraggingCelll = false
  }
}
