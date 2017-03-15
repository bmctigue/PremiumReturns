//
//  BrokerFormController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

enum BrokerFormFieldNames: String {
    case Name = "Broker Name"
    case Commission = "Commission"
}

final class BrokerFormController: NSObject {
    
    var form: Form?
    var controller: EditBrokerTableViewController
    var broker: Broker
    
    init(form: Form, controller: EditBrokerTableViewController, broker: Broker) {
        self.form = form
        self.controller = controller
        self.broker = broker
    }
    
    func formSetup() {
        
        form!
            +++ TextRow(){ row in
                row.title = "Broker Name"
                row.placeholder = "Enter a unique name"
                row.value = self.broker.name
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnBlur
                }.onChange { row in
                    if let rowValue = row.value {
                        self.broker.name = rowValue
                    }
            }
            <<< DecimalRow(BrokerFormFieldNames.Commission.rawValue){ row in
                row.useFormatterDuringInput = true
                row.title = BrokerFormFieldNames.Commission.rawValue
                row.value = 0
                row.add(rule: RuleRequired())
                }.onChange { row in
                    if let rowValue = row.value {
                        self.broker.commission = Double(rowValue)
                    }
        }
    }
}
