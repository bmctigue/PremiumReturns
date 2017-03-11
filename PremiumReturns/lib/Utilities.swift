//
//  Utilities.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

final class Utilities: NSObject {
    
    static let sharedInstance = Utilities()
    private override init() {}
    
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

}
