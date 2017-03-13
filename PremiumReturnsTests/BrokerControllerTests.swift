//
//  BrokerControllerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/6/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class BrokerControllerTests: XCTestCase {
    
    override func setUp() {
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
    }
    
    func testFind() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let key = BrokerType.brokerTypes.first!.rawValue
        let broker = BrokerController.sharedInstance.find(key: key)
        XCTAssertEqual(broker?.name, key)
    }
}
