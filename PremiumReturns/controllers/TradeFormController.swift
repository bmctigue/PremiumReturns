//
//  TradeFormController.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 2/27/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

final class TradeFormController: NSObject {
    
    var form: Form?
    var controller: TradeTableViewController?
    
    init(form: Form, controller: TradeTableViewController) {
        self.form = form
        self.controller = controller
    }
    
    func formSetup() {
        
        form!
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
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Strategies.rawValue)
                }()
            }
            <<< ActionSheetRow<String>(FormFieldNames.CurrentStrategy.rawValue) { row in
                row.title = FormFieldNames.CurrentStrategy.rawValue
                row.selectorTitle = TradeTableViewController.strategyTitle
                row.options = StrategyType.strategyTypes.map{$0.rawValue}
                row.value = StrategyType.strategyTypes.first?.rawValue
                }.onChange { row in
                    if let rowValue = row.value, let strategyType = StrategyType.strategyTypesHash[rowValue] {
                        self.controller?.currentStrategy = StrategyController.sharedInstance.find(key: strategyType.rawValue)
                        self.controller?.updateOutputFields()
                    }
            }
            
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
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.premium = Double(rowValue)
                        self.controller?.updateOutputFields()
                    }
            }
            <<< DecimalRow(FormFieldNames.MaxLoss.rawValue){ row in
                row.useFormatterDuringInput = true
                row.title = FormFieldNames.MaxLoss.rawValue
                row.value = 0
                row.formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
                }.cellSetup { cell, _  in
                    cell.textField.keyboardType = .numberPad
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.loss = Double(rowValue)
                        self.controller?.updateOutputFields()
                    }
            }
            <<< IntRow(FormFieldNames.Contracts.rawValue) { row in
                row.title = FormFieldNames.Contracts.rawValue
                row.value = self.controller?.trade.contracts
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.contracts = rowValue
                        self.controller?.updateOutputFields()
                    }
            }
            <<< IntRow(FormFieldNames.DaysToExpiration.rawValue) { row in
                row.title = FormFieldNames.DaysToExpiration.rawValue
                row.value = self.controller?.trade.daysToExpiration
                }.onChange { row in
                    if let rowValue = row.value {
                        self.controller?.trade.daysToExpiration = rowValue
                        self.controller?.updateOutputFields()
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
}
