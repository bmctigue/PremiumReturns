//
//  TradeController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/13/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import SwiftyUserDefaults

final class TradeController {
    
    static let sharedInstance = TradeController.init()
    
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func all() -> [Trade] {
        let items = realm.objects(Trade.self).sorted(byKeyPath: "date", ascending: false)
        if items.count == 0 {
            return [Trade]()
        }
        return Array(items)
    }
    
    func find(key: String) -> Trade? {
        return realm.object(ofType: Trade.self, forPrimaryKey: key)
    }
    
    func save(trade: Trade) {
        let copiedTrade = trade.copyWithPremium()
        try! realm.write {
            realm.add(copiedTrade, update: true)
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.delete(realm.objects(Trade.self))
        }
    }
    
    func updateInputFields(form: Form, premium: Double, maxLoss: Double, contracts: Int, days: Int) {
        let premiumRow: DecimalRow? = form.rowBy(tag: FormFieldNames.Premium.rawValue)
        premiumRow?.value = premium
        premiumRow?.updateCell()
        
        let maxLossRow: DecimalRow? = form.rowBy(tag: FormFieldNames.MaxLoss.rawValue)
        maxLossRow?.value = maxLoss
        maxLossRow?.updateCell()
        
        let contractsRow: IntRow? = form.rowBy(tag: FormFieldNames.Contracts.rawValue)
        contractsRow?.value = contracts
        contractsRow?.updateCell()
        
        let dteRow: IntRow? = form.rowBy(tag: FormFieldNames.DaysToExpiration.rawValue)
        dteRow?.value = days
        dteRow?.updateCell()
    }
    
    func updateOutputFields(form: Form, trade: Trade, strategy: Strategy, broker: Broker) {
        
        let commissions = trade.totalCommissions(commissionPerContract: broker.commission, legs: strategy.legs)
        
        let calculatedReturn = trade.calculate(maxProfitPercentage: strategy.maxProfitPercentage, winningProbability: strategy.winningProbability, contracts: trade.contracts, commission: commissions)
        let returnOnCapital = trade.returnOnCapital(profit: calculatedReturn, maxLoss: trade.maxLoss)
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
        
        let tickerRow: TextRow? = form.rowBy(tag: FormFieldNames.Ticker.rawValue)
        tickerRow?.value = trade.ticker.uppercased()
        if let value = tickerRow?.value {
            Defaults[.ticker] = value
        }
        tickerRow?.updateCell()
    }
    
    func resetOutputFields(form: Form) {
        let strategy = StrategyController.sharedInstance.resetStrategy()
        let strategyRow: ActionSheetRow<String>? = form.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.value = strategy.name
        strategyRow?.updateCell()
        
        let broker = BrokerController.sharedInstance.resetBroker()
        let brokerRow: ActionSheetRow<String>? = form.rowBy(tag: FormFieldNames.Broker.rawValue)
        brokerRow?.value = broker.name
        brokerRow?.updateCell()
        
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
        
        let tickerRow: TextRow? = form.rowBy(tag: FormFieldNames.Ticker.rawValue)
        if Defaults.hasKey(.ticker) {
            tickerRow?.value = Defaults[.ticker]
        } else {
            tickerRow?.value = ""
        }
        tickerRow?.updateCell()
    }
    
    func resetTrade(form: Form, trade: Trade, commission: Double) -> Trade {
        let trade = trade
        trade.premium = 0
        trade.maxLoss = 0
        trade.contracts = 1
        trade.commission = commission
        trade.daysToExpiration = TradeTableViewController.daysToExpiration
        trade.ticker = Defaults[.ticker]
        updateInputFields(form: form, premium: trade.premium, maxLoss: trade.maxLoss, contracts: trade.contracts, days: trade.daysToExpiration)
        resetOutputFields(form: form)
        return trade
    }
}


