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
    var strategy: String { set get }
    var premium: Double { set get }
    var maxLoss: Double { set get }
    var contracts: Int { set get }
    var daysToExpiration: Int { set get }
    var commissions: Double { set get }
    var maxProfitPercentage: Double { set get }
    var pop: Int { set get }
    var date: Date { set get }
    func maxProfit() -> Double
    func totalCommissions(commission: Double, legs: Int) -> Double
    func calculate(maxProfitPercentage: Double) -> Double
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double
    func returnPerDay(totalReturn: Double, days: Int) -> Double
    func copyWithPremium() -> Trade
    func reset(pop: Int, commission: Double, legs: Int, strategy: String, maxProfitPercentage: Double)
}

final class Trade: Object, TradeProtocol {
    dynamic var tradeId: String = NSUUID().uuidString
    dynamic var ticker: String = ""
    dynamic var strategy: String = ""
    dynamic var premium: Double = 0.0
    dynamic var maxLoss: Double = 0.0
    dynamic var contracts: Int = 1
    dynamic var daysToExpiration: Int = 45
    dynamic var commissions: Double = 0
    dynamic var maxProfitPercentage: Double = 0
    dynamic var pop: Int = 0
    dynamic var date: Date = Date()
    
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
        let adjustedPercentage = maxProfitPercentage/100.0
        let adjustedProbability = Double(pop)/100.0
        return ((adjustedPercentage * self.maxProfit()) * adjustedProbability) - (Double(1.0 - adjustedProbability) * maxLoss) - commissions
    }
    
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double {
        return Double((profit/maxLoss) * 100)
    }
    
    func returnPerDay(totalReturn: Double, days: Int) -> Double {
        return totalReturn/Double(days)
    }
    
    class func withPremium(premium: Double, maxLoss: Double, pop: Int, contracts: Int, commissions: Double) -> Trade {
        let attributesHash = ["premium": premium, "maxLoss": maxLoss, "pop": pop, "contracts": contracts, "commissions":commissions] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    func copyWithPremium() -> Trade {
        let attributesHash = ["ticker": self.ticker, "premium": self.premium, "maxLoss": self.maxLoss, "pop": self.pop, "contracts": self.contracts, "commissions":self.commissions, "strategy":self.strategy, "maxProfitPercentage":self.maxProfitPercentage] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    func reset(pop: Int, commission: Double, legs: Int, strategy: String, maxProfitPercentage: Double) {
        self.premium = 0
        self.maxLoss = 0
        self.pop = pop
        self.contracts = 1
        self.commissions = totalCommissions(commission: commission, legs: legs)
        self.daysToExpiration = TradeTableViewController.daysToExpiration
        self.ticker = Defaults[.ticker]
        self.strategy = strategy
        self.maxProfitPercentage = maxProfitPercentage
    }
}
