//
//  TradeControllerTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class TradeControllerTests: XCTestCase {
    
    override func setUp() {
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
    }
    
    override func tearDown() {
        ModelControllerUtilities.sharedInstance.clearAllModelControllers()
    }
    
    func testFind() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let trade = Trade.withPremium(premium: 0, maxLoss: 0, pop: 0, contracts: 1, commissions: 0)
        TradeController.sharedInstance.save(trade: trade)
        let copiedTrade = TradeController.sharedInstance.all().first!
        let key = copiedTrade.tradeId
        let foundTrade = TradeController.sharedInstance.find(key: key)
        XCTAssertEqual(trade.commissions, foundTrade?.commissions)
    }
    
    func testSave() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let trade = Trade.withPremium(premium: 0, maxLoss: 0, pop: 0, contracts: 1, commissions: 0)
        TradeController.sharedInstance.save(trade: trade)
        let copiedTrade = TradeController.sharedInstance.all().first!
        XCTAssertNotEqual(trade.tradeId, copiedTrade.tradeId)
    }
    
    func testRemoveAll() {
        ModelControllerUtilities.sharedInstance.refreshAppData()
        let trade = Trade.withPremium(premium: 0, maxLoss: 0, pop: 0, contracts: 1, commissions: 0)
        TradeController.sharedInstance.save(trade: trade)
        TradeController.sharedInstance.removeAll()
        let count = TradeController.sharedInstance.all().count
        XCTAssertEqual(count, 0)
    }
    
}
