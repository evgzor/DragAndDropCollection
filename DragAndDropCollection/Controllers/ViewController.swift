//
//  ViewController.swift
//  DragAndDropCollection
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var dragDropCollectionView: DragDropCollectionView!

  var isDraggingCelll = false
  var items = [ItemModel]()

  func lastIndexPath() -> IndexPath {
    return IndexPath(row: items.count, section: 0)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    ItemsModelLoader().loadItems { itemsList, error in
      if let listOfItems = itemsList, error == nil {
        self.items = listOfItems
        DispatchQueue.main.async {
          self.dragDropCollectionView.reloadData()
        }
      }
    }
    dragDropCollectionView.draggingDelegate = self
    dragDropCollectionView.enableDragging(true)
  }

  @IBAction func removeCell(_ sender: UIButton) {

    guard let point = sender.superview?.convert(sender.center, to: dragDropCollectionView)
    else {
      return
    }

    if let indexPath = dragDropCollectionView.indexPathForItem(at: point),
      let uuid = self.items[indexPath.row].uuid {
      let alertView =
        UIAlertController(title: "Delete item",
                          message: "Do you really want to delete the item  with identifier  \(uuid) ?",
                          preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
        UIView.animate(withDuration: 1.0, animations: {
          // self.dragDropCollectionView.setContentOffset(CGPoint.zero, animated: false)
          self.dragDropCollectionView.performBatchUpdates({
            self.items.remove(at: indexPath.row)
            self.dragDropCollectionView.deleteItems(at: [indexPath])
          })
        }, completion: nil)
      })
      let canselAction = UIAlertAction.init(title: "cancel", style: .cancel, handler: { _ in
      })
      alertView.addAction(canselAction)
      alertView.addAction(okAction)
      alertView.view.layoutIfNeeded()
      self.present(alertView, animated: true, completion: nil)
    }
  }

}

extension ViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let isAddItemCell = indexPath == self.lastIndexPath()
    let cellId = isAddItemCell ? "addCollectionViewCell" : "collectionViewCell"
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as UICollectionViewCell
    if !isAddItemCell {
      if let basicCell = cell as? BasicCell {
        basicCell.applyMode(model: self.items[indexPath.row])
      }
    }
    return cell
  }

}
