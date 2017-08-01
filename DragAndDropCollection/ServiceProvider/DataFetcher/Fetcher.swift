//
//  Fetcher.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

/// Fetch Json file in user initiated queue
public class Fetcher {
  static let shared = Fetcher()

  let queue: DispatchQueue = Loader.queue
  let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                           delegate: nil, delegateQueue: OperationQueue())
  func fetchItemsData(_ completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void) {

    self.queue.async {
      if let path = Bundle.main.path(forResource: "model", ofType: "json") {
        let urlPath = URL(fileURLWithPath: path)
        do {
          let jsonData = try Data(contentsOf: urlPath, options: .mappedIfSafe)
            completionHandler(jsonData, nil)
        } catch {
          completionHandler(nil, error)
        }
      }
    }
  }

  func fetchBackgroudImage(for url: URL,
                           completionHandler: @escaping (_ data: Data?, _ url: URL, _ error: Error?) -> Void) {
    let request = URLRequest(url: url)
    let task = session.dataTask(with: request) { (data, _, error) in
      completionHandler(data, url, error)
    }
    task.resume()
  }
}
