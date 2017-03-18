//
//  Trade.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

protocol Trade {
    var premium: Double { set get }
    var loss: Double { set get }
    var contracts: Int { set get }
    var daysToExpiration: Int { set get }
    func totalCommissions(commissionPerContract: Double, legs: Int) -> Double
    func calculate(maxProfitPercentage: Double, winningProbability: Double, contracts: Int, commissions: Double) -> Double
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double
    func returnPerDay(totalReturn: Double, days: Int) -> Double
}

struct TastyReturn: Trade {
    
    var premium: Double = 0.0
    var loss: Double = 0.0
    var contracts: Int = 1
    var daysToExpiration: Int = 45
    
    init(premium: Double, loss: Double, contracts: Int) {
        self.premium = premium
        self.loss = loss
        self.contracts = contracts
    }
    
    func totalCommissions(commissionPerContract: Double, legs: Int) -> Double {
        return commissionPerContract * Double(contracts) * Double(legs)
    }
    
    func calculate(maxProfitPercentage: Double, winningProbability: Double, contracts: Int, commissions: Double) -> Double {
        let maxProfit = Double(premium * 100 * Double(contracts))
        let adjustedPercentage = maxProfitPercentage/100.0
        let adjustedProbability = winningProbability/100.0
        return ((adjustedPercentage * maxProfit) * adjustedProbability) - (Double(1.0 - adjustedProbability) * loss) - commissions
    }
    
    func returnOnCapital(profit: Double, maxLoss: Double) -> Double {
        return Double((profit/maxLoss) * 100)
    }
    
    func returnPerDay(totalReturn: Double, days: Int) -> Double {
        return totalReturn/Double(days)
    }
}
