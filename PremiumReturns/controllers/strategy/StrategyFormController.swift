//
//  StrategyFormController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

enum StrategyFormFieldNames: String {
    case Name = "Strategy Name"
    case Legs = "Legs"
    case ProfitPercentage = "Profit Percentage"
    case WinningProbability = "Probability of Winning"
}

final class StrategyFormController: NSObject {
    
    var form: Form?
    var controller: EditStrategyTableViewController
    var strategy: Strategy
    
    init(form: Form, controller: EditStrategyTableViewController, strategy: Strategy) {
        self.form = form
        self.controller = controller
        self.strategy = strategy
    }
    
    func formSetup() {
        
        form!
            +++ TextRow(){ row in
                row.title = "Strategy Name"
                row.placeholder = "Enter a unique name"
                row.value = self.strategy.name
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnBlur
                }.onChange { row in
                    if let rowValue = row.value {
                        self.strategy.name = rowValue
                    }
            }
            <<< IntRow(StrategyFormFieldNames.Legs.rawValue) { row in
                row.title = StrategyFormFieldNames.Legs.rawValue
                row.value = self.strategy.legs
                row.add(rule: RuleRequired())
                }.onChange { row in
                    if let rowValue = row.value {
                        self.strategy.legs = rowValue
                    }
            }
            <<< DecimalRow(StrategyFormFieldNames.ProfitPercentage.rawValue){ row in
                row.useFormatterDuringInput = true
                row.title = StrategyFormFieldNames.ProfitPercentage.rawValue
                row.value = 0
                row.add(rule: RuleRequired())
                }.onChange { row in
                    if let rowValue = row.value {
                        self.strategy.maxProfitPercentage = Double(rowValue)
                    }
            }
            <<< DecimalRow(StrategyFormFieldNames.WinningProbability.rawValue){ row in
                row.useFormatterDuringInput = true
                row.title = StrategyFormFieldNames.WinningProbability.rawValue
                row.value = 0
                row.add(rule: RuleRequired())
                }.onChange { row in
                    if let rowValue = row.value {
                        self.strategy.winningProbability = Double(rowValue)
                    }
        }
    }
}
