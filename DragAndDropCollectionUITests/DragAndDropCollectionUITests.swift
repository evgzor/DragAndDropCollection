//
//  DragAndDropCollectionUITests.swift
//  DragAndDropCollectionUITests
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import XCTest
import UIKit

extension XCUIElement {
  // The following is a workaround for inputting text in the
  //simulator when the keyboard is hidden
  func setText(text: String, application: XCUIApplication) {
    UIPasteboard.general.string = text
    doubleTap()
    application.menuItems["Paste"].tap()
  }
}

class DragAndDropCollectionUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBaseFunctionality() {
      let app = XCUIApplication()
      let collectionViewsQuery = app.collectionViews
      collectionViewsQuery.cells.otherElements.containing(.staticText, identifier: "+  Add").element.tap()
      let doYouWatToAddItemAlert = app.alerts["Do you wat to add item ?"]
      doYouWatToAddItemAlert.collectionViews.textFields["link to picture"].press(forDuration: 0.7)
      let enterNameTextField =  app.otherElements.textFields["link to picture"]
      enterNameTextField.tap()
      enterNameTextField.setText(text:
        "https://vignette1.wikia.nocookie.net/tomandjerry/images/7/75/TexasTomTitle.JPG/revision/latest?cb=20140807220806",
                                 application: app)
      doYouWatToAddItemAlert.buttons["OK"].tap()
      collectionViewsQuery.children(matching: .cell).element(boundBy: 10).otherElements.children(matching: .button).element.tap()
      app.alerts["Delete item"].buttons["OK"].tap()
      
      let element = collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element
      element.press(forDuration: 1.2)
    }
  
  func testAlerts() {
    
    let app = XCUIApplication()
    let collectionViewsQuery = app.collectionViews
    collectionViewsQuery.children(matching: .cell).element(boundBy: 0).otherElements.containing(.button, identifier:"delete").element.press(forDuration: 0.7);
    app.alerts["Selected item"].buttons["OK"].tap()
    collectionViewsQuery.children(matching: .cell).element(boundBy: 5).buttons["delete"].tap()
    
    let deleteItemAlert = app.alerts["Delete item"]
    deleteItemAlert.buttons["cancel"].tap()
    collectionViewsQuery.children(matching: .cell).element(boundBy: 7).buttons["delete"].tap()
    deleteItemAlert.buttons["OK"].tap()
    
  }

}
