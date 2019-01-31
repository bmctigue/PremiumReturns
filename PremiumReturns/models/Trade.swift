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
    var ticker: String { get set }
    var strategy: String { get set }
    var premium: Double { get set }
    var maxLoss: Double { get set }
    var contracts: Int { get set }
    var legs: Int { get set }
    var commissions: Double { get set }
    var maxProfitPercentage: Int { get set }
    var pop: Int { get set }
    var date: Date { get set }
    func maxProfit() -> Double
    func totalCommissions(commission: Double) -> Double
    func calculate(maxProfitPercentage: Int) -> Double
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double
    func copyWithPremium() -> Trade
    func reset(pop: Int, commission: Double, legs: Int, strategy: String, maxProfitPercentage: Int)
}

final class Trade: Object, TradeProtocol {
    @objc dynamic var tradeId: String = NSUUID().uuidString
    @objc dynamic var ticker: String = ""
    @objc dynamic var strategy: String = ""
    @objc dynamic var premium: Double = 0.0
    @objc dynamic var maxLoss: Double = 0.0
    @objc dynamic var contracts: Int = 1
    @objc dynamic var legs: Int = 2
    @objc dynamic var commissions: Double = 0
    @objc dynamic var maxProfitPercentage: Int = 0
    @objc dynamic var pop: Int = 0
    @objc dynamic var date: Date = Date()
    
    override static func indexedProperties() -> [String] {
        return ["tradeId"]
    }
    
    override static func primaryKey() -> String? {
        return "tradeId"
    }
    
    func maxProfit() -> Double {
        return Double(premium * 100 * Double(contracts))
    }
    
    func totalCommissions(commission: Double) -> Double {
        return commission * Double(contracts) * Double(legs)
    }
    
    func calculate(maxProfitPercentage: Int) -> Double {
        let adjustedPercentage = Double(maxProfitPercentage)/100.0
        let adjustedProbability = Double(pop)/100.0
        let maxProfit = self.maxProfit()
        let result = ((adjustedPercentage * maxProfit) * adjustedProbability) - (Double(1.0 - adjustedProbability) * maxLoss * Double(contracts))
        return result - commissions
    }
    
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double {
        return Double((profit/maxLoss) * 100)
    }
    
    func returnPerDay(totalReturn: Double, days: Int) -> Double {
        return totalReturn/Double(days)
    }
    
    class func withPremium(premium: Double, maxLoss: Double, pop: Int, contracts: Int, commissions: Double, legs: Int) -> Trade {
        let attributesHash = ["premium": premium, "maxLoss": maxLoss, "pop": pop, "contracts": contracts, "commissions":commissions, "legs":legs] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    func copyWithPremium() -> Trade {
        let attributesHash = ["ticker": self.ticker, "premium": self.premium, "maxLoss": self.maxLoss, "pop": self.pop, "contracts": self.contracts, "commissions": self.commissions, "strategy": self.strategy, "maxProfitPercentage": self.maxProfitPercentage, "legs":legs] as [String : Any]
        return Trade(value: attributesHash)
    }
    
    func reset(pop: Int, commission: Double, legs: Int, strategy: String, maxProfitPercentage: Int) {
        self.premium = 0
        self.maxLoss = 0
        self.pop = pop
        self.contracts = 1
        self.legs = legs
        self.commissions = totalCommissions(commission: commission)
        self.ticker = Defaults[.ticker]
        self.strategy = strategy
        self.maxProfitPercentage = maxProfitPercentage
    }
    
    func resetStrategyBroker(pop: Int, commission: Double, legs: Int, strategy: String, maxProfitPercentage: Int) {
        self.pop = pop
        self.legs = legs
        self.commissions = totalCommissions(commission: commission)
        self.ticker = Defaults[.ticker]
        self.strategy = strategy
        self.maxProfitPercentage = maxProfitPercentage
    }
}
