//
//  ItemModel.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 14/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation

class ItemModel: NSCoding {
  fileprivate struct SerializationKeys {
    static let imageUrlString = "imageUrlString"
    static let uuid = "uuid"
    static let items = "items"
  }
  // MARK: Properties
  public var imageUrlString: String?
  public var uuid: String?
  convenience init?(json: [String: Any]?) {
    guard let uuid = json?["uuid"] as? String,
      let imageUrlString = json?["imageUrlString"] as? String
      else {
        return nil
    }
    self.init(uuid: uuid, imageUrlString: imageUrlString)
  }
  init(uuid: String, imageUrlString: String) {
    self.uuid = uuid
    self.imageUrlString = imageUrlString
  }
  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = imageUrlString { dictionary[SerializationKeys.imageUrlString] = value }
    if let value = uuid { dictionary[SerializationKeys.uuid] = value }
    return dictionary
  }
  class func modelsFromDictionary(dictionary: [String: Any]) -> [ItemModel]? {
    var models: [ItemModel] = []
    guard let array = dictionary[SerializationKeys.items] as? [[String: Any]] else {
      return nil
    }
    for item in array {
      if let parsedItem = ItemModel.init(json: item) {
        models.append(parsedItem)
      }
    }
    return models
  }

  class func makeNewItem(with link: String) -> ItemModel? {
      let uuid = NSUUID().uuidString.lowercased()
    if link.isEmpty {
      return nil
    }
    return ItemModel.init(uuid: uuid, imageUrlString: link)
  }

  // MARK: NSCoding Protocol
  required public init?(coder aDecoder: NSCoder) {
    self.imageUrlString = aDecoder.decodeObject(forKey: SerializationKeys.imageUrlString) as? String
    self.uuid = aDecoder.decodeObject(forKey: SerializationKeys.uuid) as? String
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(imageUrlString, forKey: SerializationKeys.imageUrlString)
    aCoder.encode(uuid, forKey: SerializationKeys.uuid)
  }

}
