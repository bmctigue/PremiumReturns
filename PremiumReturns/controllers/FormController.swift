//
//  FormController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

final class FormController {
    
    static let sharedInstance = FormController.init()
    
    func headerView(text: String) -> HeaderFooterView<UIView> {
        var header = HeaderFooterView<UIView>(.callback({
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: CGFloat(TradeTableViewController.headerHeight)))
            view.backgroundColor = .flatWhite
            let label = UILabel(frame: CGRect(x: 15.0, y: 0, width: view.frame.width - 15.0, height: view.frame.height))
            label.font = UIFont(name: FontType.Primary.fontName, size: FontType.Primary.fontSize)
            label.text = text
            view.addSubview(label)
            return view
        }))
        header.height = {CGFloat(Constants.headerHeight)}
        return header
    }
    
    func rowIsEmpty(row: TextRow?) -> Bool {
        if let textRow = row {
            if textRow.value == nil || textRow.value == "" {
                return true
            }
        }
        return false
    }
    
    func alertTextRowIsEmpty(name: String, controller: UIViewController?) {
        if let controller = controller {
            let title = "The \(name) field is empty"
            let message = "Please fill in the \(name) field"
            Utilities.sharedInstance.displayAlert(controller: controller, title: title, message: message)
        }
    }
    
    func share(trade: Trade, controller: UIViewController) {
        TradeController.sharedInstance.save(trade: trade)
        let title = "Share your Trade"
        let message = "Your \(trade.ticker) trade was shared!"
        Utilities.sharedInstance.displayAlert(controller: controller, title: title, message: message)
    }
}
