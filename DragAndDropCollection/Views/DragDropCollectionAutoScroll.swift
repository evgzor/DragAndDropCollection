//
//  DragDropCollection+AutoScroll.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

extension DragDropCollectionView {
    enum AutoScrollDirection: Int {
        case invalid = 0
        case towardsOrigin = 1
        case awayFromOrigin = 2
    }

    func autoScroll(_ direction: AutoScrollDirection) {
        let currentLongPressTouchLocation = self.longPressRecognizer.location(in: self)
        var increment: CGFloat
        var newContentOffset: CGPoint
        if direction == AutoScrollDirection.towardsOrigin {
            increment = -50.0
        } else {
            increment = 50.0
        }
        newContentOffset = CGPoint(x: self.contentOffset.x, y: self.contentOffset.y + increment)
      guard let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout else {
        return
      }
        if flowLayout.scrollDirection == UICollectionViewScrollDirection.horizontal {
            newContentOffset = CGPoint(x: self.contentOffset.x + increment, y: self.contentOffset.y)
        }
        if (direction == AutoScrollDirection.towardsOrigin && newContentOffset.y < 0) ||
          (direction == AutoScrollDirection.awayFromOrigin &&
            newContentOffset.y > self.contentSize.height - self.frame.height) {
            dispatchOnMainQueueAfter(0.3, closure: { () -> Void in
                self.isAutoScrolling = false
            })
        } else {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0, options: UIViewAnimationOptions.curveLinear,
                           animations: { () -> Void in
                self.setContentOffset(newContentOffset, animated: false)
                if self.draggingView != nil {
                    if flowLayout.scrollDirection == UICollectionViewScrollDirection.vertical {
                        var draggingFrame = self.draggingView!.frame
                        draggingFrame.origin.y += increment
                        self.draggingView!.frame = draggingFrame
                    } else {
                        var draggingFrame = self.draggingView!.frame
                        draggingFrame.origin.x += increment
                        self.draggingView!.frame = draggingFrame
                    }
                }
            }) { (_) -> Void in
                dispatchOnMainQueueAfter(0.0, closure: { () -> Void in
                    var updatedTouchLocationWithNewOffset =
                      CGPoint(x: currentLongPressTouchLocation.x,
                              y: currentLongPressTouchLocation.y + increment)
                    if flowLayout.scrollDirection == UICollectionViewScrollDirection.horizontal {
                        updatedTouchLocationWithNewOffset = CGPoint(x: currentLongPressTouchLocation.x + increment,
                                                                    y: currentLongPressTouchLocation.y)
                    }
                    let scroller = self.shouldAutoScroll(updatedTouchLocationWithNewOffset)
                    if scroller.shouldScroll {
                        self.autoScroll(scroller.direction)
                    } else {
                        self.isAutoScrolling = false
                    }
                })
            }
        }
    }

    func shouldAutoScroll(_ previousTouchLocation: CGPoint) -> (shouldScroll: Bool, direction: AutoScrollDirection) {
        let previousTouchLocation = self.convert(previousTouchLocation, to: self.superview)
        let currentTouchLocation = self.longPressRecognizer.location(in: self.superview)

        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            if !Double(currentTouchLocation.x).isNaN && !Double(currentTouchLocation.y).isNaN {
                if distanceBetweenPoints(previousTouchLocation, secondPoint: currentTouchLocation) < CGFloat(20.0) {
                    let scrollDirection = flowLayout.scrollDirection
                    var scrollBoundsSize: CGSize
                    let scrollBoundsLength: CGFloat = 50.0
                    var scrollRectAtEnd: CGRect
                    switch scrollDirection {

                    case .horizontal:
                        scrollBoundsSize = CGSize(width: scrollBoundsLength, height: self.frame.height)
                        scrollRectAtEnd = CGRect(x: self.frame.origin.x + self.frame.width - scrollBoundsSize.width,
                                                 y: self.frame.origin.y,
                                                 width: scrollBoundsSize.width, height: self.frame.height)

                    case .vertical:
                        scrollBoundsSize = CGSize(width: self.frame.width, height: scrollBoundsLength)
                        scrollRectAtEnd = CGRect(x: self.frame.origin.x,
                                                 y: self.frame.origin.y + self.frame.height - scrollBoundsSize.height,
                                                 width: self.frame.width,
                                                 height: scrollBoundsSize.height)
                    }
                    let scrollRectAtOrigin = CGRect(origin: self.frame.origin, size: scrollBoundsSize)
                    if scrollRectAtOrigin.contains(currentTouchLocation) {
                        return (true, AutoScrollDirection.towardsOrigin)
                    } else if scrollRectAtEnd.contains(currentTouchLocation) {
                        return (true, AutoScrollDirection.awayFromOrigin)
                    }
                }
            }
        }
        return (false, AutoScrollDirection.invalid)
  }

}
