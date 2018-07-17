//
//  LiveTradeFormController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 4/3/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

final class LiveTradeFormController: NSObject {

    var form: Form?
    var trade: Trade!
    var profit: Double = 0
    
    init(form: Form, trade: Trade) {
        self.form = form
        self.trade = trade
        profit = trade.calculate(maxProfitPercentage: self.trade.maxProfitPercentage)
    }
    
    func formSetup() {
        formLiveTradeSetup()
        formReturnsSetup()
        formInputSetup()
    }
    
    func formLiveTradeSetup() {
        form!
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Trade.rawValue)
                }()
            }
            <<< DateRow(FormFieldNames.TradeDate.rawValue) { row in
                row.title = FormFieldNames.TradeDate.rawValue
                row.value = self.trade.date
            }
            <<< LabelRow(FormFieldNames.Strategy.rawValue) { row in
                row.title = FormFieldNames.Strategy.rawValue
                row.value = self.trade.strategy
        }
    }
    
    func formReturnsSetup() {
        form!
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Returns.rawValue)
                }()
            }
            <<< LabelRow(FormFieldNames.MaxProfit.rawValue) { row in
                row.title = FormFieldNames.MaxProfit.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: trade.maxProfit(), showType: true)
            }
            <<< LabelRow(FormFieldNames.ExpectedReturn.rawValue) { row in
                row.title = FormFieldNames.ExpectedReturn.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: profit, showType: true)
            }
            <<< LabelRow(FormFieldNames.ROC.rawValue) { row in
                row.title = FormFieldNames.ROC.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: trade.returnOnCapital(profit: profit, maxLoss: trade.maxLoss), showType: false)
            }
    }
    
    func formInputSetup() {
        form!
            +++ Section() { section in
                section.header = {
                    return FormController.sharedInstance.headerView(text: SectionNames.Input.rawValue)
                }()
            }
            <<< LabelRow(FormFieldNames.Premium.rawValue) { row in
                row.title = FormFieldNames.Premium.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: self.trade.premium, showType: true)
            }
            <<< LabelRow(FormFieldNames.MaxLoss.rawValue) { row in
                row.title = FormFieldNames.MaxLoss.rawValue
                row.value = Utilities.sharedInstance.formatOutput(value: self.trade.maxLoss, showType: true)
            }
            <<< LabelRow(FormFieldNames.POP.rawValue) { row in
                row.title = FormFieldNames.POP.rawValue
                row.value = "\(self.trade.pop)"
            }
            <<< LabelRow(FormFieldNames.Contracts.rawValue) { row in
                row.title = FormFieldNames.Contracts.rawValue
                row.value = "\(self.trade.contracts)"
                
            }
    }
}
