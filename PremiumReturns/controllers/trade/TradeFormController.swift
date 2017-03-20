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
    case Data = "TRADE"
    case Settings = "SETTINGS"
    case Returns = "RETURNS"
    case Costs = "COSTS"
}

enum FormFieldNames: String {
    case Strategy = "Select a Strategy"
    case Broker = "Select a Broker"
    case Trade = "Expected Return"
    case ROC = "Return on Capital (%)"
    case Premium = "Premium"
    case MaxLoss = "Max Loss (BPR)"
    case Contracts = "Contracts"
    case Commissions = "Commissions"
    case DaysToExpiration = "Days To Expiration"
    case ReturnPerDay = "Return Per Day"
}

final class TradeFormController: NSObject {
    
    var form: Form?
    var controller: TradeTableViewController?
    var strategies = StrategyController.sharedInstance.all()
    var firstStrategy: Strategy?
    var brokers = BrokerController.sharedInstance.all()
    var firstBroker: Broker?
    
    init(form: Form, controller: TradeTableViewController) {
        self.form = form
        self.controller = controller
    }
    
    func refreshForm() {
        strategies = StrategyController.sharedInstance.all()
        firstStrategy = strategies.first
        let strategyRow: ActionSheetRow<String>?  = form?.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.options = strategies.map{$0.name}
        strategyRow?.reload()
        
        brokers = BrokerController.sharedInstance.all()
        firstBroker = brokers.first
        let brokerRow: ActionSheetRow<String>?  = form?.rowBy(tag: FormFieldNames.Broker.rawValue)
        brokerRow?.options = brokers.map{$0.name}
        brokerRow?.reload()
    }
    
    func formSetup() {
        
        form!
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Data.rawValue)
                }()
            }
            <<< DecimalRow(FormFieldNames.Premium.rawValue){ row in
                row.useFormatterDuringInput = true
                row.title = FormFieldNames.Premium.rawValue
                row.value = 0
                row.formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.premium = Double(rowValue)
                        self.updateOutputFields()
                    }
            }
            <<< DecimalRow(FormFieldNames.MaxLoss.rawValue){ row in
                row.useFormatterDuringInput = true
                row.title = FormFieldNames.MaxLoss.rawValue
                row.value = 0
                row.formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.maxLoss = Double(rowValue)
                        self.updateOutputFields()
                    }
            }
            <<< IntRow(FormFieldNames.Contracts.rawValue) { row in
                row.title = FormFieldNames.Contracts.rawValue
                row.value = self.controller?.trade.contracts
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.contracts = rowValue
                        self.updateOutputFields()
                    }
            }
            <<< IntRow(FormFieldNames.DaysToExpiration.rawValue) { row in
                row.title = FormFieldNames.DaysToExpiration.rawValue
                row.value = self.controller?.trade.daysToExpiration
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.daysToExpiration = rowValue
                        self.updateOutputFields()
                    }
            }
            
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Returns.rawValue)
                }()
            }
            <<< LabelRow(FormFieldNames.Trade.rawValue){ row in
                row.title = FormFieldNames.Trade.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
            }
            <<< LabelRow(FormFieldNames.ROC.rawValue){ row in
                row.title = FormFieldNames.ROC.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: false)
            }
            <<< LabelRow(FormFieldNames.ReturnPerDay.rawValue){ row in
                row.title = FormFieldNames.ReturnPerDay.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: false)
            }
            
            +++ Section(){ section in
                section.tag = "SettingsSection"
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Settings.rawValue)
                }()
            }
            <<< ActionSheetRow<String>(FormFieldNames.Strategy.rawValue) { row in
                row.title = FormFieldNames.Strategy.rawValue
                row.selectorTitle = FormFieldNames.Strategy.rawValue
                row.options = strategies.map{$0.name}
                row.value = firstStrategy?.name
                }.onChange { row in
                    if let rowValue = row.value, let strategy = StrategyController.sharedInstance.find(name: rowValue).first {
                        self.controller?.currentStrategy = strategy
                        self.updateOutputFields()
                        Defaults[.strategy] = strategy.strategyId
                    }
            }
            <<< ActionSheetRow<String>(FormFieldNames.Broker.rawValue) { row in
                row.title = FormFieldNames.Broker.rawValue
                row.selectorTitle = FormFieldNames.Broker.rawValue
                row.options = brokers.map{$0.name}
                row.value = firstBroker?.name
                }.onChange { row in
                    if let rowValue = row.value, let broker = BrokerController.sharedInstance.find(name: rowValue).first {
                        self.controller?.currentBroker = broker
                        self.updateOutputFields()
                        Defaults[.broker] = broker.brokerId
                    }
            }
            
            +++ Section(){ section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Costs.rawValue)
                }()
            }
            <<< LabelRow(FormFieldNames.Commissions.rawValue){ row in
                row.title = FormFieldNames.Commissions.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        }
    }
    
    func updateOutputFields() {
        TradeController.sharedInstance.updateOutputFields(form: self.controller!.form, trade: self.controller!.trade, strategy: self.controller!.currentStrategy!, broker: self.controller!.currentBroker!)
    }
}
