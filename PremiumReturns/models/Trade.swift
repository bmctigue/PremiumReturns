//
//  Trade.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import RealmSwift

protocol TradeProtocol {
    var tradeId: String { get }
    var ticker: String { set get }
    var premium: Double { set get }
    var maxLoss: Double { set get }
    var contracts: Int { set get }
    var daysToExpiration: Int { set get }
    var commission: Double { set get }
    var date: Date { set get }
    func maxProfit(contracts: Int) -> Double
    func totalCommissions(commissionPerContract: Double, legs: Int) -> Double
    func calculate(maxProfitPercentage: Double, winningProbability: Double, contracts: Int, commission: Double) -> Double
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double
    func returnPerDay(totalReturn: Double, days: Int) -> Double
}

class Trade: Object, TradeProtocol {
    dynamic var tradeId: String = NSUUID().uuidString
    dynamic var ticker: String = ""
    dynamic var premium: Double = 0.0
    dynamic var maxLoss: Double = 0.0
    dynamic var contracts: Int = 1
    dynamic var daysToExpiration: Int = 45
    dynamic var commission: Double = 0
    dynamic var date: Date = Date()
    
    class func withPremium(premium: Double, maxLoss: Double, contracts: Int, commission: Double) -> Trade {
        let attributesHash = ["premium": premium, "maxLoss": maxLoss, "contracts": contracts, "commission":commission] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    override static func indexedProperties() -> [String] {
        return ["tradeId"]
    }
    
    override static func primaryKey() -> String? {
        return "tradeId"
    }
    
    func maxProfit(contracts: Int) -> Double {
        return Double(premium * 100 * Double(contracts))
    }
    
    func totalCommissions(commissionPerContract: Double, legs: Int) -> Double {
        return commissionPerContract * Double(contracts) * Double(legs)
    }
    
    func calculate(maxProfitPercentage: Double, winningProbability: Double, contracts: Int, commission: Double) -> Double {
        let maxProfit = self.maxProfit(contracts: contracts)
        let adjustedPercentage = maxProfitPercentage/100.0
        let adjustedProbability = winningProbability/100.0
        return ((adjustedPercentage * maxProfit) * adjustedProbability) - (Double(1.0 - adjustedProbability) * maxLoss) - commission
    }
    
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double {
        return Double((profit/maxLoss) * 100)
    }
    
    func returnPerDay(totalReturn: Double, days: Int) -> Double {
        return totalReturn/Double(days)
    }
    
    func copyWithPremium() -> Trade {
        let attributesHash = ["ticker": self.ticker, "premium": self.premium, "maxLoss": self.maxLoss, "contracts": self.contracts, "commission":self.commission] as [String : Any]
        return Trade(value: attributesHash)
    }
}
