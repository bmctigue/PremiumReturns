//
//  TradeTests.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import XCTest
@testable import PremiumReturns

class TradeTests: XCTestCase {
    
    static var premium: Double = 1.0
    static var maxLoss: Double = 100
    static var contracts: Int = 1
    static var legs: Int = 4
    static var commission: Double = 1.0
    static var totalReturns = 90.0
    static var days = 45
    static var pop = 100
    static var maxProfitPercentage = 100
    
    var trade: Trade!
    var commissions: Double!
    var calculatedReturn: Double!
    
    override func setUp() {
        trade = Trade.withPremium(premium: TradeTests.premium, maxLoss: TradeTests.maxLoss, pop: TradeTests.pop, contracts: TradeTests.contracts, commissions: TradeTests.commission, legs: TradeTests.legs)
        trade.maxProfitPercentage = TradeTests.maxProfitPercentage
        updateCalculated(trade)
    }
    
    func testMaxProfit() {
        XCTAssertEqual(roundValue(trade.maxProfit, toDecimalPlaces: 2), 100.0)
        trade.contracts = 2
        XCTAssertEqual(roundValue(trade.maxProfit, toDecimalPlaces: 2), 200.0)
    }
    
    func testMaxProfit50() {
        trade.maxProfitPercentage = 50
        XCTAssertEqual(roundValue(trade.maxProfit, toDecimalPlaces: 2), 50.0)
        trade.contracts = 2
        XCTAssertEqual(roundValue(trade.maxProfit, toDecimalPlaces: 2), 100.0)
    }
    
    func testTotalCommissions() {
        XCTAssertEqual(commissions, 4.0)
        trade.contracts = 2
        updateCalculated(trade)
        XCTAssertEqual(commissions, 8.0)
    }
    
    func testCalculate() {
        XCTAssertEqual(roundValue(calculatedReturn, toDecimalPlaces: 2), 96.0)
        trade.contracts = 2
        updateCalculated(trade)
        XCTAssertEqual(roundValue(calculatedReturn, toDecimalPlaces: 2), 192.0)
    }
    
    func testReturnOnCapital() {
        var roc = trade.returnOnCapital(profit: calculatedReturn, maxLoss: TradeTests.maxLoss)
        XCTAssertEqual(roundValue(roc, toDecimalPlaces: 2), 96.0)
        trade.contracts = 2
        updateCalculated(trade)
        roc = trade.returnOnCapital(profit: calculatedReturn, maxLoss: TradeTests.maxLoss)
        XCTAssertEqual(roundValue(roc, toDecimalPlaces: 2), 96.0)
    }
    
    func testReturnPerDay() {
        let returnPerDay = trade.returnPerDay(totalReturn: TradeTests.totalReturns, days: TradeTests.days)
        XCTAssertEqual(returnPerDay, 2.0)
    }
    
    func testCopyWithPremium() {
        let copiedTrade = trade.copyWithPremium()
        XCTAssertEqual(copiedTrade.premium, trade!.premium)
    }
    
    func roundValue(_ value: Double, toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }
    
    func updateCalculated(_ trade: Trade) {
        commissions = trade.totalCommissions(commission: TradeTests.commission)
        trade.commissions = commissions
        calculatedReturn = trade.calculate(maxProfitPercentage: 100)
    }
}

