//
//  TradeFormFieldController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/23/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import SwiftyUserDefaults

enum CalculationKey: String {
    case Commissions = "Commissions"
    case MaxProfit = "MaxProfit"
    case CalculatedReturn = "CalculatedReturn"
    case ReturnOnCapital = "ReturnOnCapital"
}

final class TradeFormFieldController {
    
    static let sharedInstance = TradeFormFieldController()
    
    func updateInputFields(form: Form, premium: Double, maxLoss: Double, pop: Int, contracts: Int, maxProfitPercentage: Int) {
        let premiumRow: DecimalRow? = form.rowBy(tag: FormFieldNames.Premium.rawValue)
        premiumRow?.value = premium
        premiumRow?.updateCell()
        
        let maxLossRow: DecimalRow? = form.rowBy(tag: FormFieldNames.MaxLoss.rawValue)
        maxLossRow?.value = maxLoss
        maxLossRow?.updateCell()
        
        let popRow: IntRow? = form.rowBy(tag: FormFieldNames.POP.rawValue)
        popRow?.title = FormFieldNames.POP.rawValue + "(\(maxProfitPercentage))"
        popRow?.value = pop
        popRow?.updateCell()
        
        let contractsRow: IntRow? = form.rowBy(tag: FormFieldNames.Contracts.rawValue)
        contractsRow?.value = contracts
        contractsRow?.updateCell()
    }
    
    func updateOutputFields(form: Form, trade: Trade, calculatedFieldValueHash: [CalculationKey:Double]) {
        let maxProfitRow: LabelRow? = form.rowBy(tag: FormFieldNames.MaxProfit.rawValue)
        maxProfitRow?.value = Utilities.sharedInstance.formatOutput(value: calculatedFieldValueHash[CalculationKey.MaxProfit]!, showType: true)
        maxProfitRow?.updateCell()
        
        let expectedReturnRow: LabelRow? = form.rowBy(tag: FormFieldNames.ExpectedReturn.rawValue)
        let returnValue =  Utilities.sharedInstance.formatOutput(value: calculatedFieldValueHash[CalculationKey.CalculatedReturn]!, showType: true)
        expectedReturnRow?.value = "\(returnValue)"
        expectedReturnRow?.updateCell()

        let rocRow: LabelRow? = form.rowBy(tag: FormFieldNames.ROC.rawValue)
        let rocValue = Utilities.sharedInstance.formatOutput(value: calculatedFieldValueHash[CalculationKey.ReturnOnCapital]!, showType: false)
        rocRow?.value = "\(rocValue)"
        rocRow?.updateCell()
        
        let tickerRow: TextRow? = form.rowBy(tag: FormFieldNames.Ticker.rawValue)
        tickerRow?.value = trade.ticker.uppercased()
        if let value = tickerRow?.value {
            Defaults[.ticker] = value
        }
        tickerRow?.updateCell()
        
        let commissionsRow: LabelRow? = form.rowBy(tag: FormFieldNames.Commissions.rawValue)
        let commissionsValue = Utilities.sharedInstance.formatOutput(value: calculatedFieldValueHash[CalculationKey.Commissions]!, showType: true)
        commissionsRow?.value = "\(commissionsValue)"
        commissionsRow?.updateCell()
    }
    
    func resetOutputFields(form: Form, trade: Trade, commission: Double, legs: Int) {
        
        let strategy = StrategyController.sharedInstance.resetStrategy()
        let strategyRow: ActionSheetRow<String>? = form.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.value = strategy.name
        strategyRow?.updateCell()
        
        let broker = BrokerController.sharedInstance.resetBroker()
        let brokerRow: ActionSheetRow<String>? = form.rowBy(tag: FormFieldNames.Broker.rawValue)
        brokerRow?.value = broker.name
        brokerRow?.updateCell()
        
        let calculatedReturn = trade.calculate(maxProfitPercentage: strategy.maxProfitPercentage)
        let returnOnCapital = trade.returnOnCapital(profit: calculatedReturn, maxLoss: trade.maxLoss)
        
        let calculatedFieldValueHash: [CalculationKey:Double] = [CalculationKey.Commissions:trade.commissions, CalculationKey.MaxProfit:0, CalculationKey.CalculatedReturn:calculatedReturn, CalculationKey.ReturnOnCapital: returnOnCapital]
        updateOutputFields(form: form, trade: trade, calculatedFieldValueHash: calculatedFieldValueHash)
        
        let tickerRow: TextRow? = form.rowBy(tag: FormFieldNames.Ticker.rawValue)
        if Defaults.hasKey(.ticker) {
            tickerRow?.value = Defaults[.ticker]
        } else {
            tickerRow?.value = ""
        }
        tickerRow?.updateCell()
    }
    
    func calculatedHash(trade: Trade, strategy: Strategy, broker: Broker) -> [CalculationKey:Double] {
        let commissions = trade.totalCommissions(commission: broker.commission)
        trade.commissions = commissions
        let calculatedReturn = trade.calculate(maxProfitPercentage: strategy.maxProfitPercentage)
        let returnOnCapital = trade.returnOnCapital(profit: calculatedReturn, maxLoss: trade.maxLoss)
        return [CalculationKey.Commissions:commissions, CalculationKey.MaxProfit:trade.maxProfit, CalculationKey.CalculatedReturn:calculatedReturn, CalculationKey.ReturnOnCapital: returnOnCapital]
    }

}
