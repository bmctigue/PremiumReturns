//: Playground - noun: a place where people can play

import UIKit

/*

 Values for calculation:
 
 Percentage to close for max profit(premium): maxProfitPercentage
 Premium: premium
 
 Value for a loss: loss
 
 Probability of being a winner: pop
 Probability of being a loser: losingProbability
 
 // Commissions
 Commission value: commissionPerContract
 Number of contracts: numberContracts
 commissions = commissionPerContract * numberContracts

 // Calculate the expected value(return)
 trade = ((maxProfitPercentage * maxProfit) * pop) - (losingProbability * loss) - commissions
 
 Trade
 =======
 premium
 loss
 contracts
 daysToExpiration
 -----
 - maxProfit() -> Double
 - totalCommissions(legs: Int) -> Double
 - calculate(maxProfitPercentage: Double, pop: Double) -> Double
 - returnOnCapital(profit: Double, maxLoss: Double) -> Double
 - returnPerDay(totalReturn: Double, days: Int) -> Double
 =======
 
 Strategy
 =======
 type
 legs
 maxProfitPercentage
 pop
 =======
 
 StrategyFactory
 =======
 - strategy(type)
 =======
 
 StrategyTableViewController
 =======
 + addCustomStrategy
 rowSelected - open editStrategy
 swipe to delete strategy
 =======
 
 EditCustomStrategy
 ==================
 modal
    new - form view with empty fields
    edit - form view with selected strategy values
 cancel
    dismiss
 done
    saveStrategy
 ==================
 
 Broker
 ======
 name
 commission
 ======
 
 TODO
 ====
 Add code for Realm to use remote data store
 Change winning probability to pop
 Add pop field to the trade input fields
  Add live trade view
 ====
 
*/

