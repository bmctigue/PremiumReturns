//
//  BrokerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/22/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class BrokerTests: XCTestCase {
    
    func testBrokerTypeFor() {
        let testBroker = Broker.forType(type: .TastyWorks, name: BrokerType.TastyWorks.rawValue, commission: 1.0)
        let testBrokerType = testBroker.brokerTypeFor()
        XCTAssertEqual(testBroker.brokerType, testBrokerType.rawValue)
    }
    
    func testCopyWithID() {
        let testBroker = Broker.forType(type: .TastyWorks, name: "Test", commission: 1)
        let brokerCopy = testBroker.copyWithID()
        XCTAssertEqual(testBroker.brokerId, brokerCopy.brokerId)
    }
}
