//
//  ItemModelLoader.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation

/// Load items model
public class ItemsModelLoader: Loader {
  func loadItems(completionHandler: @escaping (_ items: [ItemModel]?, _ error: Error?) -> Void) {
    Loader.queue.async {

      Fetcher.shared.fetchItemsData({ (data, error) in
        do {
          if let jsonData = data {
            let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)

            if let jsonDic = jsonResult as? [String: Any] {
              let items = ItemModel.modelsFromDictionary(dictionary: jsonDic)
              completionHandler(items, nil)
            }
          }

        } catch {
          completionHandler(nil, error)
        }
      })
    }
  }
}
