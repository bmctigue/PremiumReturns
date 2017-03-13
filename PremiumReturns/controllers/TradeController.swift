//
//  TradeController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/13/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

final class TradeController {
    
    static let sharedInstance = TradeController.init()
    
    func updateInputFields(form: Form, premium: Double, loss: Double, contracts: Int, days: Int) {
        let premiumRow: DecimalRow? = form.rowBy(tag: FormFieldNames.Premium.rawValue)
        premiumRow?.value = premium
        premiumRow?.updateCell()
        
        let lossRow: DecimalRow? = form.rowBy(tag: FormFieldNames.MaxLoss.rawValue)
        lossRow?.value = loss
        lossRow?.updateCell()
        
        let contractsRow: IntRow? = form.rowBy(tag: FormFieldNames.Contracts.rawValue)
        contractsRow?.value = contracts
        contractsRow?.updateCell()
        
        let dteRow: IntRow? = form.rowBy(tag: FormFieldNames.DaysToExpiration.rawValue)
        dteRow?.value = days
        dteRow?.updateCell()
    }
    
    func updateOutputFields(form: Form, trade: Trade, strategy: Strategy, broker: Broker) {
        
        let commissions = trade.totalCommissions(commissionPerContract: broker.commission, legs: strategy.legs)
        
        let calculatedReturn = trade.calculate(maxProfitPercentage: strategy.maxProfitPercentage, winningProbability: strategy.winningProbability, contracts: trade.contracts, commissions: commissions)
        let returnOnCapital = trade.returnOnCapital(profit: calculatedReturn, maxLoss: trade.loss)
        let returnPerDay = trade.returnPerDay(totalReturn: returnOnCapital, days: trade.daysToExpiration)
        
        let expectedReturnRow: LabelRow? = form.rowBy(tag: FormFieldNames.Trade.rawValue)
        let returnValue =  Utilities.sharedInstance.formatOutput(value: calculatedReturn, showType: true)
        expectedReturnRow?.value = "\(returnValue)"
        expectedReturnRow?.updateCell()
        
        let rocRow: LabelRow? = form.rowBy(tag: FormFieldNames.ROC.rawValue)
        let rocValue = Utilities.sharedInstance.formatOutput(value: returnOnCapital, showType: false)
        rocRow?.value = "\(rocValue)"
        rocRow?.updateCell()
        
        let commissionsRow: LabelRow? = form.rowBy(tag: FormFieldNames.Commissions.rawValue)
        let commissionsValue = Utilities.sharedInstance.formatOutput(value: commissions, showType: true)
        commissionsRow?.value = "\(commissionsValue)"
        commissionsRow?.updateCell()
        
        let returnPerDayRow: LabelRow? = form.rowBy(tag: FormFieldNames.ReturnPerDay.rawValue)
        let returnPerDayRowValue = Utilities.sharedInstance.formatOutput(value: returnPerDay, showType: true)
        returnPerDayRow?.value = "\(returnPerDayRowValue)"
        returnPerDayRow?.updateCell()
    }
    
    func resetOutputFields(form: Form) {
        let strategies = StrategyController.sharedInstance.all()
        let firstStrategy = strategies.first
        let strategyRow: ActionSheetRow<String>? = form.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.value = firstStrategy?.name
        strategyRow?.updateCell()
        
        let expectedReturnRow: LabelRow? = form.rowBy(tag: FormFieldNames.Trade.rawValue)
        expectedReturnRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        expectedReturnRow?.updateCell()
        
        let rocRow: LabelRow? = form.rowBy(tag: FormFieldNames.ROC.rawValue)
        rocRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: false)
        rocRow?.updateCell()
        
        let commissionsRow: LabelRow? = form.rowBy(tag: FormFieldNames.Commissions.rawValue)
        commissionsRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        commissionsRow?.updateCell()
        
        let returnPerDayRow: LabelRow? = form.rowBy(tag: FormFieldNames.ReturnPerDay.rawValue)
        returnPerDayRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        returnPerDayRow?.updateCell()
    }
    
    func resetTrade(form: Form, trade: Trade) -> Trade {
        var trade = trade
        trade.premium = 0
        trade.loss = 0
        trade.contracts = 1
        trade.daysToExpiration = TradeTableViewController.daysToExpiration
        updateInputFields(form: form, premium: trade.premium, loss: trade.loss, contracts: trade.contracts, days: trade.daysToExpiration)
        resetOutputFields(form: form)
        return trade
    }
}


