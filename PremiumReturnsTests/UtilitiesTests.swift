//
//  UtilitiesTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class UtilitiesTests: XCTestCase {
    
    func testFormatOutput() {
        var value: Double = 0
        var result = Utilities.sharedInstance.formatOutput(value: value, showType: true)
        XCTAssertEqual(result, "$0.00")
        value = 0.76
        result = Utilities.sharedInstance.formatOutput(value: value, showType: true)
        XCTAssertEqual(result, "$0.76")
        value = 3.42
        result = Utilities.sharedInstance.formatOutput(value: value, showType: true)
        XCTAssertEqual(result, "$3.42")
        value = 24
        result = Utilities.sharedInstance.formatOutput(value: value, showType: true)
        XCTAssertEqual(result, "$24.00")
        value = 76.6
        result = Utilities.sharedInstance.formatOutput(value: value, showType: false)
        XCTAssertEqual(result, "76.60")
        value = 24.12
        result = Utilities.sharedInstance.formatOutput(value: value, showType: false)
        XCTAssertEqual(result, "24.12")
        value = 698.11
        result = Utilities.sharedInstance.formatOutput(value: value, showType: false)
        XCTAssertEqual(result, "698.11")
        value = -100.00
        result = Utilities.sharedInstance.formatOutput(value: value, showType: false)
        XCTAssertEqual(result, "-100.00")
        value = Double.infinity
        result = Utilities.sharedInstance.formatOutput(value: value, showType: false)
        XCTAssertEqual(result, " - ")
    }
    
}
