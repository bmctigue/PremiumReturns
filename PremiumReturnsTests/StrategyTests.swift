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
        var testStrategy = Strategy.forType(type: .IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        var testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .IronFly, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .VerticalSpread, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .Straddle, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .Strangle, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .RatioSpread, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .JadeLizard, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
        testStrategy = Strategy.forType(type: .Custom, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        testStrategyType = testStrategy.strategyTypeForStrategy()
        XCTAssertEqual(testStrategy.strategyType,testStrategyType.rawValue)
    }
    
    func testCopyWithID() {
        let testStrategy = Strategy.forType(type: .IronCondor, name: "Test", legs: 4, maxProfitPercentage: 0, pop: 0)
        let strategyCopy = testStrategy.copyWithID()
        XCTAssertEqual(testStrategy.strategyId, strategyCopy.strategyId)
    }
}
