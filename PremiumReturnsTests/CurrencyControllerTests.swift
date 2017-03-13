//
//  CurrencyControllerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/25/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
import Eureka
@testable import PremiumReturns

class CurrencyControllerTests: XCTestCase {
    
    func testDefaultCurrencyFormatter() {
        let formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
        XCTAssertEqual(formatter.locale, .current)
        XCTAssertEqual(formatter.numberStyle, .currency)
    }
    
}
