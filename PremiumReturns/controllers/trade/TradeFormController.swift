//
//  TradeFormController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/27/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import SwiftyUserDefaults

enum SectionNames: String {
    case Input = "TRADE DATA"
    case Settings = "SETTINGS"
    case Returns = "RETURNS"
    case Costs = "COSTS"
    case Trades = "TRADES"
    case Trade = "TRADE"
}

enum FormFieldNames: String {
    case Strategy = "Strategy"
    case Broker = "Broker"
    case ExpectedReturn = "Expected Return"
    case ROC = "Return on Capital (%)"
    case Premium = "Premium"
    case MaxLoss = "Max Loss"
    case POP = "POP"
    case Contracts = "Contracts"
    case Commissions = "Commissions"
    case DaysToExpiration = "Days To Expiration"
    case Save = "Save"
    case Ticker = "Ticker"
    case MaxProfit = "Max Profit"
    case TradeDate = "Trade Date"
}

class TradeFormController: NSObject {
    
    static let shareText = "Tap to Save"
    
    var form: Form
    var controller: TradeTableViewController!
    var strategies = StrategyController.sharedInstance.all()
    var firstStrategy: Strategy?
    var brokers = BrokerController.sharedInstance.all()
    var firstBroker: Broker?
    var inputRows: [BaseRow] = []
    var currencyFormatter: InputFormatter
    
    init(form: Form, controller: TradeTableViewController, currencyFormatter: InputFormatter = CurrencyController.sharedInstance.currencyFormatter) {
        self.form = form
        self.controller = controller
        self.currencyFormatter = currencyFormatter
    }
    
    func refreshForm() {
        strategies = StrategyController.sharedInstance.all()
        firstStrategy = strategies.first
        let strategyRow: ActionSheetRow<String>?  = form.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.options = strategies.map { $0.name }
        strategyRow?.reload()
        
        brokers = BrokerController.sharedInstance.all()
        firstBroker = brokers.first
        let brokerRow: ActionSheetRow<String>?  = form.rowBy(tag: FormFieldNames.Broker.rawValue)
        brokerRow?.options = brokers.map { $0.name }
        brokerRow?.reload()
    }
    
    func formSetup() {
        formInputSetup()
        formReturnsSetup()
        formTradesSetup()
        formSettingsSetup()
        formCostsSetup()
        setupInputFieldsForValidation()
    }
    
    func formInputSetup() {
        form
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Input.rawValue)
                }()
                }
                <<< DecimalRow(FormFieldNames.Premium.rawValue) { row in
                    row.useFormatterDuringInput = true
                    row.title = FormFieldNames.Premium.rawValue
                    row.value = 0
                    row.formatter = currencyFormatter
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller.trade.premium = Double(rowValue)
                            self.updateOutputFields()
                        }
                }
                <<< DecimalRow(FormFieldNames.MaxLoss.rawValue) { row in
                    row.useFormatterDuringInput = true
                    row.title = FormFieldNames.MaxLoss.rawValue
                    row.value = 0
                    row.formatter = CurrencyController.sharedInstance.truncatedCurrFormatter
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller.trade.maxLoss = Double(rowValue)
                            self.updateOutputFields()
                        }
                }
                <<< IntRow(FormFieldNames.POP.rawValue) { row in
                    row.useFormatterDuringInput = true
                    row.title = FormFieldNames.POP.rawValue + "(\(Int(self.controller!.currentStrategy!.maxProfitPercentage)))"
                    row.value = 0
                    row.formatter = CurrencyController.sharedInstance.popFormatter
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller.trade.pop = rowValue
                            self.updateOutputFields()
                        }
                }
                <<< IntRow(FormFieldNames.Contracts.rawValue) { row in
                    row.title = FormFieldNames.Contracts.rawValue
                    row.value = self.controller.trade.contracts
                    }.onChange { row in
                        if let rowValue = row.value {
                            self.controller.trade.contracts = rowValue
                            self.updateOutputFields()
                        }
                }
    }
    
    func formReturnsSetup() {
        form
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Returns.rawValue)
                }()
                }
                <<< LabelRow(FormFieldNames.MaxProfit.rawValue) { row in
                    row.title = FormFieldNames.MaxProfit.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
                }
                <<< LabelRow(FormFieldNames.ExpectedReturn.rawValue) { row in
                    row.title = FormFieldNames.ExpectedReturn.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
                }
                <<< LabelRow(FormFieldNames.ROC.rawValue) { row in
                    row.title = FormFieldNames.ROC.rawValue
                    row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: false)
                }
    }
    
    func formTradesSetup() {
        form
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Trades.rawValue)
                }()
            }
            <<< TextRow(FormFieldNames.Ticker.rawValue) { row in
                row.title = FormFieldNames.Ticker.rawValue
                row.value = self.controller.trade.ticker
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller.trade.ticker = rowValue
                        self.updateOutputFields()
                        Defaults[.ticker] = rowValue
                    }
            }
            <<< LabelRow(FormFieldNames.Save.rawValue) { row in
                row.title = FormFieldNames.Save.rawValue
                row.value = TradeFormController.shareText
                }.onCellSelection { cell, row in
                    let tickerRow: TextRow? = self.form.rowBy(tag: FormFieldNames.Ticker.rawValue)
                    if let row = tickerRow {
                        let rowIsEmpty = FormController.sharedInstance.rowIsEmpty(row: row)
                        if rowIsEmpty {
                            FormController.sharedInstance.alertTextRowIsEmpty(name: FormFieldNames.Ticker.rawValue, controller: self.controller)
                        } else {
                            if FormController.sharedInstance.numericRowsAreNonZero(rows: self.inputRows) {
                                FormController.sharedInstance.share(trade: self.controller.trade, controller: self.controller)
                            } else {
                                FormController.sharedInstance.alertInputRowIsZero(controller: self.controller)
                            }
                        }
                    }
        }
    }
    
    func formSettingsSetup() {
        form
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Settings.rawValue)
                }()
            }
            <<< ActionSheetRow<String>(FormFieldNames.Strategy.rawValue) { row in
                row.title = FormFieldNames.Strategy.rawValue
                row.selectorTitle = FormFieldNames.Strategy.rawValue
                row.options = strategies.map { $0.name }
                row.value = firstStrategy?.name
                }.onChange { row in
                    if let rowValue = row.value, let strategy = StrategyController.sharedInstance.find(name: rowValue).first {
                        self.controller.currentStrategy = strategy
                        self.controller.trade.strategy = strategy.name
                        self.controller.trade.legs = self.controller!.currentStrategy!.legs
                        self.controller.trade.commissions = self.controller!.trade.totalCommissions(commission: self.controller!.currentBroker!.commission)
                        let popRow: IntRow? = self.form.rowBy(tag: FormFieldNames.POP.rawValue)
                        popRow!.title = FormFieldNames.POP.rawValue + "(\(strategy.maxProfitPercentage))"
                        self.updateInputFields()
                        self.updateOutputFields()
                        Defaults[.strategy] = strategy.strategyId
                    }
            }
            <<< ActionSheetRow<String>(FormFieldNames.Broker.rawValue) { row in
                row.title = FormFieldNames.Broker.rawValue
                row.selectorTitle = FormFieldNames.Broker.rawValue
                row.options = brokers.map { $0.name }
                row.value = firstBroker?.name
                }.onChange { row in
                    if let rowValue = row.value, let broker = BrokerController.sharedInstance.find(name: rowValue).first {
                        self.controller.currentBroker = broker
                        self.controller.trade.legs = self.controller!.currentStrategy!.legs
                        self.controller.trade.commissions = self.controller!.trade.totalCommissions(commission: self.controller!.currentBroker!.commission)
                        self.updateOutputFields()
                        Defaults[.broker] = broker.brokerId
                    }
        }
    }
    
    func formCostsSetup() {
        form
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Costs.rawValue)
                }()
            }
            <<< LabelRow(FormFieldNames.Commissions.rawValue) { row in
                row.title = FormFieldNames.Commissions.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        }
    }
    
    func setupInputFieldsForValidation() {
        let premiumRow: DecimalRow? = self.form.rowBy(tag: FormFieldNames.Premium.rawValue)
        let lossRow: DecimalRow? = self.form.rowBy(tag: FormFieldNames.MaxLoss.rawValue)
        let popRow: IntRow? = self.form.rowBy(tag: FormFieldNames.POP.rawValue)
        let contractsRow: IntRow? = self.form.rowBy(tag: FormFieldNames.Contracts.rawValue)
        let dteRow: IntRow? = self.form.rowBy(tag: FormFieldNames.DaysToExpiration.rawValue)
        
        if let premium = premiumRow, let loss = lossRow, let pop = popRow, let contracts = contractsRow, let dte = dteRow {
            inputRows = [premium, loss, pop, contracts, dte]
        }
    }
    
    func updateInputFields() {
        TradeFormFieldController.sharedInstance.updateInputFields(form: self.form, premium: self.controller.trade.premium, maxLoss: self.controller.trade.maxLoss, pop: self.controller.trade.pop, contracts: self.controller.trade.contracts, maxProfitPercentage: self.controller.currentStrategy?.maxProfitPercentage ?? 0)
    }
    
    func updateOutputFields() {
        let calculatedFieldValueHash = TradeFormFieldController.sharedInstance.calculatedHash(trade: self.controller!.trade, strategy: self.controller!.currentStrategy!, broker: self.controller!.currentBroker!)
        TradeFormFieldController.sharedInstance.updateOutputFields(form: self.controller!.form, trade: self.controller!.trade, calculatedFieldValueHash: calculatedFieldValueHash)
    }
}
