//
//  Trade.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

protocol TradeProtocol {
    var premium: Double { set get }
    var maxLoss: Double { set get }
    var contracts: Int { set get }
    var daysToExpiration: Int { set get }
    var commission: Double { set get }
    func maxProfit(contracts: Int) -> Double
    func totalCommissions(commissionPerContract: Double, legs: Int) -> Double
    func calculate(maxProfitPercentage: Double, winningProbability: Double, contracts: Int, commission: Double) -> Double
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double
    func returnPerDay(totalReturn: Double, days: Int) -> Double
}

struct Trade: TradeProtocol {
    
    var premium: Double = 0.0
    var maxLoss: Double = 0.0
    var contracts: Int = 1
    var daysToExpiration: Int = 45
    var commission: Double = 0
    
    init(premium: Double, maxLoss: Double, contracts: Int, commission: Double) {
        self.premium = premium
        self.maxLoss = maxLoss
        self.contracts = contracts
        self.commission = commission
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
}
