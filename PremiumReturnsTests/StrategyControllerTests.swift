//
//  StrategyControllerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/5/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class StrategyControllerTests: XCTestCase {
    
    override func setUp() {
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
    }
    
    func testFind() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let key = StrategyType.strategyTypes.first!.rawValue
        let strategy = StrategyController.sharedInstance.find(key: key)
        XCTAssertEqual(strategy?.name, key)
    }
}
