//
//  DragAndDropCollectionTests.swift
//  DragAndDropCollectionTests
//
//  Created by Eugene Zorin on 11/07/2017.
//  Copyright © 2017 Eugene Zorin. All rights reserved.
//

import XCTest
@testable import DragAndDropCollection

class DragAndDropCollectionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReadJson() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      let expectation = self.expectation(description: "Request should retrive list")
      ItemsModelLoader().loadItems { (items, error) in
        if let error = error {
          XCTFail("Data request error: \(error.localizedDescription)")
        }
        XCTAssertEqual(items?.count, 11)
        XCTAssertEqual(items?[10].uuid, "543e2adf-10de-1c4d-ac74-2884daf5ecc8")
        XCTAssertNotNil(items?[10].imageUrlString)
        XCTAssertTrue((items?[10].imageUrlString?.contains("http"))!)
        expectation.fulfill()
      }
      self.wait(for: [expectation], timeout: 10)
    }
  
  func testDownloadPicture() {
    let expectation = self.expectation(description: "Request should retrive image")
    let imageUrl = URL(string: "https://vignette2.wikia.nocookie.net/tomandjerry/images/9/96/Tom-jerry-wizard-disneyscreencaps.com-2787.jpg//revision/latest?cb=20140807220806")
    ImageLoader().loadImage(url: imageUrl) { (image, error) in
      XCTAssertEqual(image?.size, CGSize(width: 1920.0, height: 1080.0))
      expectation.fulfill()
    }
   self.wait(for: [expectation], timeout: 10)
  }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
