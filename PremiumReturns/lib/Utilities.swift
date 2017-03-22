//
//  Utilities.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

final class Utilities: NSObject {
    
    var dateFormatter: DateFormatter!
    
    static let sharedInstance = Utilities()
    private override init() {
        super.init()
        self.dateFormatter = defaultDateFormatter()
    }
    
    func formatOutput(value: Double, showType: Bool) -> String {
        var result = ""
        let formatter = CurrencyController.sharedInstance.defaultCurrencyFormatter()
        if value.isFinite {
            result = formatter.string(for: value)!
            if !showType {
                if value < 0 {
                    result.remove(at: result.startIndex)
                    result.remove(at: result.startIndex)
                    result = "-" + result
                } else {
                    result.remove(at: result.startIndex)
                }
            }
        } else {
            result = " - "
        }
        return result
    }
    
    func displayAlert(controller: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let CancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(CancelAction)
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = controller.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: controller.view.bounds.size.width / 2.0, y: controller.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadDataIfEmpty() {
        if StrategyController.sharedInstance.all().count == 0 {
            StrategyController.sharedInstance.loadDefault()
        }
        
        if BrokerController.sharedInstance.all().count == 0 {
            BrokerController.sharedInstance.loadDefault()
        }
    }
    
    func defaultDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatString
        return dateFormatter
    }

}
