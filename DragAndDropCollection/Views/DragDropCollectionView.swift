//
//  DragDropCollectionView.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

class DragDropCollectionView: UICollectionView, UIGestureRecognizerDelegate {

  weak var draggingDelegate: DrapDropCollectionViewDelegate?

  var longPressRecognizer: UILongPressGestureRecognizer = {
    let longPressRecognizer = UILongPressGestureRecognizer()
    longPressRecognizer.delaysTouchesBegan = false
    longPressRecognizer.cancelsTouchesInView = false
    longPressRecognizer.numberOfTouchesRequired = 1
    longPressRecognizer.minimumPressDuration = 1.0
    longPressRecognizer.allowableMovement = 10.0
    return longPressRecognizer
  }()

  var draggedCellIndexPath: IndexPath?
  var draggingView: UIView?
  var touchOffsetFromCenterOfCell: CGPoint?
  let pingInterval = 0.3
  var isAutoScrolling = false

  override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(width: UIViewNoIntrinsicMetric, height: self.contentSize.height)
  }

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    longPressRecognizer.addTarget(self, action: #selector(DragDropCollectionView.handleLongPress(_:)))
    longPressRecognizer.isEnabled = false
    self.addGestureRecognizer(longPressRecognizer)

  }

  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
  }
  

  func handleLongPress(_ longPressRecognizer: UILongPressGestureRecognizer) {
    let touchLocation = longPressRecognizer.location(in: self)
    switch longPressRecognizer.state {
    case .began:
      self.longPressBegan(at: touchLocation)
    case .changed:
      self.longPressChanged(at: touchLocation)
    case .ended:
      self.longPressEnded(at: touchLocation)
    default: ()
    }
  }

  func enableDragging(_ enable: Bool) {
    if enable {
      longPressRecognizer.isEnabled = true
    } else {
      longPressRecognizer.isEnabled = false
    }
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                         shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

    if draggedCellIndexPath != nil {
      return false
    }
    return true
  }

  fileprivate func shouldSwapCells(_ previousTouchLocation: CGPoint) -> (shouldSwap: Bool, newIndexPath: IndexPath?) {

    var shouldSwap = false
    var newIndexPath: IndexPath?
    let currentTouchLocation = self.longPressRecognizer.location(in: self)

    if !Double(currentTouchLocation.x).isNaN && !Double(currentTouchLocation.y).isNaN {

      if distanceBetweenPoints(previousTouchLocation, secondPoint: currentTouchLocation) < CGFloat(20.0) {
        if let newIndexPathForCell = self.indexPathForItem(at: currentTouchLocation) {
          if newIndexPathForCell != self.draggedCellIndexPath {
            shouldSwap = true
            newIndexPath = newIndexPathForCell
          }
        }
      }
    }
    return (shouldSwap, newIndexPath)
  }

  func swapDraggedCellWithCellAtIndexPath(_ newIndexPath: IndexPath) {

    self.performBatchUpdates({
      self.moveItem(at: self.draggedCellIndexPath! as IndexPath, to: newIndexPath as IndexPath)
    }, completion: nil)
    let draggedCell = self.cellForItem(at: newIndexPath as IndexPath)!
    draggedCell.alpha = 0
    self.draggingDelegate?.dragDropCollectionViewDidMoveCell(self.draggedCellIndexPath!, toNewIndexPath: newIndexPath)
    self.draggedCellIndexPath = newIndexPath
  }
  
//MARK: private methods prosess longpress action drag and drop
  func longPressBegan(at touchLocation: CGPoint)  {
    draggedCellIndexPath = self.indexPathForItem(at: touchLocation)
    if let draggedCellIndexPath = draggedCellIndexPath {
      draggingDelegate?.dragDropCollectionViewDraggingDidBeginWithCell(draggedCellIndexPath)
      if !longPressRecognizer.isEnabled {
        return
      }
      if let draggedCell = self.cellForItem(at: draggedCellIndexPath as IndexPath) {
        draggingView = UIImageView(image: getRasterizedImageCopyOfCell(draggedCell))
        draggingView?.center = draggedCell.center
        
        guard let draginggView = self.draggingView else {
          return
        }
        self.addSubview(draginggView)
        draggedCell.alpha = 0.0
        touchOffsetFromCenterOfCell = CGPoint(x: draggedCell.center.x - touchLocation.x,
                                              y: draggedCell.center.y - touchLocation.y)
      }
      UIView.animate(withDuration: 0.4, animations: { () -> Void in
        self.draggingView!.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.draggingView!.alpha = 0.8
      })
    }
  }
  
  func longPressChanged(at touchLocation: CGPoint) {
    if draggedCellIndexPath != nil {
      draggingView?.center = CGPoint(x: touchLocation.x + (touchOffsetFromCenterOfCell?.x ?? 0),
                                     y: touchLocation.y + (touchOffsetFromCenterOfCell?.y ?? 0))
      
      if !isAutoScrolling {
        dispatchOnMainQueueAfter(pingInterval, closure: { () -> Void in
          let scroller = self.shouldAutoScroll(touchLocation)
          if  scroller.shouldScroll {
            self.autoScroll(scroller.direction)
            self.isAutoScrolling = true
          }
        })
      }
      dispatchOnMainQueueAfter(pingInterval, closure: { () -> Void in
        let shouldSwapCellsTuple = self.shouldSwapCells(touchLocation)
        if let newIndexPath = shouldSwapCellsTuple.newIndexPath, shouldSwapCellsTuple.shouldSwap {
          self.swapDraggedCellWithCellAtIndexPath(newIndexPath)
        }
      })
    }
  }
  
  func longPressEnded(at touchLocation: CGPoint) {
    if let indexPath =  draggedCellIndexPath {
      let draggedCell = self.cellForItem(at: indexPath)
      UIView.animate(withDuration: 0.4, animations: { () -> Void in
        self.draggingView?.transform = CGAffineTransform.identity
        self.draggingView?.alpha = 1.0
        if let center = draggedCell?.center, draggedCell != nil {
          self.draggingView?.center = center
        }
      }, completion: { (_) -> Void in
        self.draggingView!.removeFromSuperview()
        self.draggingView = nil
        draggedCell?.alpha = 1.0
        self.draggedCellIndexPath = nil
        self.draggingDelegate?.dragDropCollectionViewDraggingDidEndForCell(indexPath)
      })
    }
  }


}
