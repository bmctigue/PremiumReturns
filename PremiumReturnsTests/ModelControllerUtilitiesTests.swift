//
//  ModelControllerUtilitiesTests.swift
//  BiasBike
//
//  Created by Bruce McTigue on 9/15/16.
//  Copyright © 2016 tiguer. All rights reserved.
//

import XCTest
@testable import TastyReturns

class ModelControllerUtilitiesTests: XCTestCase {
    
    override func setUp() {
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
    }
    
    func testRefreshAppData() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let strategies = StrategyController.sharedInstance.all()
        XCTAssertEqual(strategies.count, StrategyType.strategyTypes.count)
        let brokers = BrokerController.sharedInstance.all()
        XCTAssertEqual(brokers.count, BrokerType.brokerTypes.count)
    }
    
    func testClearAllModelControllers() {
        let strategies = StrategyController.sharedInstance.all()
        XCTAssertEqual(strategies.count, 0)
        let brokers = BrokerController.sharedInstance.all()
        XCTAssertEqual(brokers.count, 0)
    }
    
    func testLoadAllModelControllers() {
        ModelControllerUtilities.sharedInstance.loadAllModelControllers()
        let strategies = StrategyController.sharedInstance.all()
        XCTAssertEqual(strategies.count, StrategyType.strategyTypes.count)
        let brokers = BrokerController.sharedInstance.all()
        XCTAssertEqual(brokers.count, BrokerType.brokerTypes.count)
    }
    
    func testSaveAllModelControllers() {
        ModelControllerUtilities.sharedInstance.loadAllModelControllers()
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
        StrategyController.sharedInstance.loadDefault()
        BrokerController.sharedInstance.loadDefault()
        let strategies = StrategyController.sharedInstance.all()
        XCTAssertEqual(strategies.count, StrategyType.strategyTypes.count)
        let brokers = BrokerController.sharedInstance.all()
        XCTAssertEqual(brokers.count, BrokerType.brokerTypes.count)
    }
}
