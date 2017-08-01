//
//  DrapDropCollectionViewDelegate.swift
//  DragginCells
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation

/// drag and drop collection view delegate
protocol DrapDropCollectionViewDelegate: class {
    /// calls after cell has moved
    ///
    /// - Parameters:
    ///   - initialIndexPath: old index path position
    ///   - newIndexPath: mew index path position
    func dragDropCollectionViewDidMoveCell(_ initialIndexPath: IndexPath, toNewIndexPath newIndexPath: IndexPath)
    /// calls after movenment has started to move
    ///
    /// - Parameter indexPath: starting indexPath location
    func dragDropCollectionViewDraggingDidBeginWithCell(_ indexPath: IndexPath)
    /// Dragging finished
    ///
    /// - Parameter indexPath: finished location index cell
    func dragDropCollectionViewDraggingDidEndForCell(_ indexPath: IndexPath)
}
