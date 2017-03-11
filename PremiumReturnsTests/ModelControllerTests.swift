//
//  ModelControllerTests.swift
//  BiasBike
//
//  Created by Bruce McTigue on 9/10/16.
//  Copyright © 2016 tiguer. All rights reserved.
//

import XCTest
@testable import TastyReturns

class ModelControllerTests: XCTestCase {
    
    func testClear() {
        let modelController = ModelController.init()
        modelController.clear()
        XCTAssertTrue(true)
    }
}
