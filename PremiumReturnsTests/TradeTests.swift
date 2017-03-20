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
    
    static var premium: Double = 2.22
    static var maxLoss: Double = 78
    static var contracts: Int = 1
    static var legs: Int = 4
    static var commission: Double = 1.0
    static var totalReturns = 90.0
    static var days = 45
    
    var trade: Trade?
    var commissions: Double?
    var calculatedReturn: Double?
    
    override func setUp() {
        trade = Trade(premium: TradeTests.premium, maxLoss: TradeTests.maxLoss, contracts: TradeTests.contracts, commission: TradeTests.commission)
        commissions = trade!.totalCommissions(commissionPerContract: TradeTests.commission, legs: TradeTests.legs)
        calculatedReturn = trade!.calculate(maxProfitPercentage: 25, winningProbability: 75, contracts: TradeTests.contracts, commission: commissions!)
    }
    
    func testMaxProfit() {
        let maxProfit = trade?.maxProfit(contracts: trade!.contracts)
        XCTAssertEqual(roundValue(maxProfit!,toDecimalPlaces: 2), 222.00)
    }
    
    func testTotalCommissions() {
        XCTAssertEqual(commissions!, 4.0)
    }
    
    func testCalculate() {
        XCTAssertEqual(roundValue(calculatedReturn!,toDecimalPlaces: 2), 18.13)
    }
    
    func testReturnOnCapital() {
        let roc = trade!.returnOnCapital(profit: calculatedReturn!, maxLoss: TradeTests.maxLoss)
        XCTAssertEqual(roundValue(roc,toDecimalPlaces: 2), 23.24)
    }
    
    func testReturnPerDay() {
        let returnPerDay = trade!.returnPerDay(totalReturn: TradeTests.totalReturns, days: TradeTests.days)
        XCTAssertEqual(returnPerDay, 2.0)
    }
    
    func roundValue(_ value: Double, toDecimalPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded() / divisor
    }
    
}
