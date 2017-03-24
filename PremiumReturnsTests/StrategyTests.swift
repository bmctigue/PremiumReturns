//
//  StrategyTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/13/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class StrategyTests: XCTestCase {
    
    func testCopyWithID() {
        let testStrategy = Strategy.forType(type: .IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        let strategyCopy = testStrategy.copyWithID()
        XCTAssertEqual(testStrategy.strategyId, strategyCopy.strategyId)
    }
}
