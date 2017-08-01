//
//  Loader.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation

/// Basic class for load data
public class Loader {
  static let queue = DispatchQueue.global(qos: .userInitiated)

  static let fetcher = Fetcher.shared
}
