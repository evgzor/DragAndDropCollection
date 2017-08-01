//
//  Tools.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

extension String {
  func appendingPathComponent(_ string: String) -> String {
    return URL(fileURLWithPath: self).appendingPathComponent(string).path
  }
}

public func dispatchOnMainQueueAfter(_ delay: Double, closure:@escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay,
                                qos: DispatchQoS.userInteractive,
                                flags: DispatchWorkItemFlags.enforceQoS, execute: closure)
}

public func distanceBetweenPoints(_ firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
  let xDistance = firstPoint.x - secondPoint.x
  let yDistance = firstPoint.y - secondPoint.y
  return sqrt(xDistance * xDistance + yDistance * yDistance)
}
