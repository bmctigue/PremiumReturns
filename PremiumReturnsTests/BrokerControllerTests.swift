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
        let firstBroker = BrokerController.sharedInstance.all().first!
        let key = firstBroker.brokerId
        let strategy = BrokerController.sharedInstance.find(key: key)
        XCTAssertEqual(firstBroker.name, strategy?.name)
    }
    
    func testFindByName() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstBroker = BrokerController.sharedInstance.all().first!
        let key = firstBroker.name
        let strategies = BrokerController.sharedInstance.find(name: key)
        XCTAssertEqual(firstBroker.name, strategies.first?.name)
    }
    
    func testRemove() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstBroker = BrokerController.sharedInstance.all().first!
        BrokerController.sharedInstance.remove(broker: firstBroker)
        let count = BrokerController.sharedInstance.all().count
        XCTAssertEqual(count, BrokerType.brokerTypes.count - 2)
    }
    
    func testRemoveAll() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        BrokerController.sharedInstance.removeAll()
        let count = BrokerController.sharedInstance.all().count
        XCTAssertEqual(count, 0)
    }
    
    func testIsUnique() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let firstBroker = BrokerController.sharedInstance.all().first!
        var isUniqueBroker = BrokerController.sharedInstance.isUnique(name: firstBroker.name)
        XCTAssertFalse(isUniqueBroker)
        let testBroker = Broker.forType(type: .TastyWorks, name: "Test", commission: 1.0)
        isUniqueBroker = BrokerController.sharedInstance.isUnique(name: testBroker.name)
        XCTAssertTrue(isUniqueBroker)
    }
    
    func testBrokerTypeFor() {
        let testBroker = Broker.forType(type: .TastyWorks, name: BrokerType.TastyWorks.rawValue, commission: 1.0)
        let testBrokerType = BrokerController.sharedInstance.brokerTypeFor(broker: testBroker)
        XCTAssertEqual(testBroker.brokerType,testBrokerType.rawValue)
    }
    
    func testResetBroker() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        var firstBroker = BrokerController.sharedInstance.resetBroker()
        XCTAssertEqual(firstBroker.brokerType, BrokerType.TastyWorks.rawValue)
        BrokerController.sharedInstance.removeAll()
        firstBroker = BrokerController.sharedInstance.resetBroker()
        XCTAssertEqual(firstBroker.brokerType, BrokerType.TastyWorks.rawValue)
    }
}
