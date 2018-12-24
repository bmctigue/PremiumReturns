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
    
    func testStrategyTypeFor() {
        var testStrategy = Strategy.forType(.IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        var testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.IronFly, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.VerticalSpread, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.Straddle, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.Strangle, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.RatioSpread, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.JadeLizard, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
        testStrategy = Strategy.forType(.Custom, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType, testStrategyType.rawValue)
    }
    
    func testCopyWithID() {
        let testStrategy = Strategy.forType(.IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        let strategyCopy = testStrategy.copyWithID()
        XCTAssertEqual(testStrategy.strategyId, strategyCopy.strategyId)
    }
}
