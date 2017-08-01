//
//  ViewContriller+CollectionViewDelegate.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 15/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if isDraggingCelll {
      return
    }
    if indexPath.row == self.items.count {
      self.dragDropCollectionView.longPressRecognizer.cancelsTouchesInView = true
      let alertView = UIAlertController(title: "Do you wat to add item ?",
                                        message: "Please enter picture link", preferredStyle: .alert)
      alertView.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
        textField.placeholder = "link to picture"
      })
      let confirmAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        let newPictureLink =  alertView.textFields?[0].text?.replacingOccurrences(of: "\\", with: "")
        if let  newLink = newPictureLink ,
          let newItem  = ItemModel.makeNewItem(with: newLink) {
          self.items.append(newItem)
          self.dragDropCollectionView.performBatchUpdates({
            self.dragDropCollectionView.insertItems(at: [indexPath])
          }, completion: nil)
        }
      })
      alertView.addAction(confirmAction)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alertView.addAction(cancelAction)
      present(alertView, animated: true, completion: { _ in
        alertView.view.layoutIfNeeded()
      })
    } else {
      let uuid = self.items[indexPath.row].uuid ?? "undefined"
      let alertView = UIAlertController(title: "Selected item",
                                        message: "You have selected the item with identifier   \(uuid)",
        preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertView.addAction(okAction)
      alertView.view.layoutIfNeeded()
      self.present(alertView, animated: true, completion: nil)
    }
  }
}
