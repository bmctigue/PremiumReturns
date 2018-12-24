//
//  CurrencyController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/24/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

final class CurrencyController: NSObject {
    
    lazy var currencyFormatter = defaultCurrencyFormatter()
    
    static let sharedInstance = CurrencyController()
    private override init() {}
    
    private func defaultCurrencyFormatter() -> CurrencyFormatter {
        let formatter = CurrencyFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        return formatter
    }
}

class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.count ?? 0) - (oldValue?.count ?? 0))) ?? position
    }
}
