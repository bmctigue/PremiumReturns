//
//  FormControllerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 4/7/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
import Eureka
@testable import PremiumReturns

class FormControllerTests: XCTestCase {
    
    func testRowIsEmpty() {
        let testRow = TextRow() { row in
        }
        XCTAssertTrue(FormController.sharedInstance.rowIsEmpty(row: testRow))
        testRow.value = ""
        XCTAssertTrue(FormController.sharedInstance.rowIsEmpty(row: testRow))
        testRow.value = "Test"
        XCTAssertFalse(FormController.sharedInstance.rowIsEmpty(row: testRow))
    }
    
    func testNumericRowIsNonZero() {
        let testRow = DecimalRow() { row in
            row.value = 0
        }
        let baseRows: [BaseRow] = [testRow]
        XCTAssertFalse(FormController.sharedInstance.numericRowsAreNonZero(rows: baseRows))
        testRow.value = 1
        XCTAssertTrue(FormController.sharedInstance.numericRowsAreNonZero(rows: baseRows))
    }
}
