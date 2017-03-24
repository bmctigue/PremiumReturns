//
//  Trade.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyUserDefaults

protocol TradeProtocol {
    var tradeId: String { get }
    var ticker: String { set get }
    var premium: Double { set get }
    var maxLoss: Double { set get }
    var contracts: Int { set get }
    var daysToExpiration: Int { set get }
    var commission: Double { set get }
    var pop: Int { set get }
    var date: Date { set get }
    func maxProfit() -> Double
    func totalCommissions(commission: Double, legs: Int) -> Double
    func calculate(maxProfitPercentage: Double) -> Double
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double
    func returnPerDay(totalReturn: Double, days: Int) -> Double
    func copyWithPremium() -> Trade
    func reset(pop: Int, commission: Double, legs: Int)
}

final class Trade: Object, TradeProtocol {
    dynamic var tradeId: String = NSUUID().uuidString
    dynamic var ticker: String = ""
    dynamic var premium: Double = 0.0
    dynamic var maxLoss: Double = 0.0
    dynamic var contracts: Int = 1
    dynamic var daysToExpiration: Int = 45
    dynamic var commission: Double = 0
    dynamic var pop: Int = 0
    dynamic var date: Date = Date()
    
    class func withPremium(premium: Double, maxLoss: Double, pop: Int, contracts: Int, commission: Double) -> Trade {
        let attributesHash = ["premium": premium, "maxLoss": maxLoss, "pop": pop, "contracts": contracts, "commission":commission] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    override static func indexedProperties() -> [String] {
        return ["tradeId"]
    }
    
    override static func primaryKey() -> String? {
        return "tradeId"
    }
    
    func maxProfit() -> Double {
        return Double(premium * 100 * Double(contracts))
    }
    
    func totalCommissions(commission: Double, legs: Int) -> Double {
        return commission * Double(contracts) * Double(legs)
    }
    
    func calculate(maxProfitPercentage: Double) -> Double {
        let maxProfit = self.maxProfit()
        let adjustedPercentage = maxProfitPercentage/100.0
        let adjustedProbability = Double(pop)/100.0
        return ((adjustedPercentage * maxProfit) * adjustedProbability) - (Double(1.0 - adjustedProbability) * maxLoss) - commission
    }
    
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double {
        return Double((profit/maxLoss) * 100)
    }
    
    func returnPerDay(totalReturn: Double, days: Int) -> Double {
        return totalReturn/Double(days)
    }
    
    func copyWithPremium() -> Trade {
        let attributesHash = ["ticker": self.ticker, "premium": self.premium, "maxLoss": self.maxLoss, "pop": self.pop, "contracts": self.contracts, "commission":self.commission] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    func reset(pop: Int, commission: Double, legs: Int) {
        self.premium = 0
        self.maxLoss = 0
        self.pop = pop
        self.contracts = 1
        self.commission = totalCommissions(commission: commission, legs: legs)
        self.daysToExpiration = TradeTableViewController.daysToExpiration
        self.ticker = Defaults[.ticker]
    }
}
