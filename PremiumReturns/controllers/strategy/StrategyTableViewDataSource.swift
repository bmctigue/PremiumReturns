//
//  StrategyTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewDataSource: ItemTableViewDataSource {
    
    override func updateDataSource() {
        items = StrategyController.sharedInstance.all()
    }
    
    override func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteItemIndexPath {
            let strategy = items[indexPath.row]  as! Strategy
            if items.count == 1 {
                let title = "Delete \(strategy.name)"
                let message = "Sorry, you can't delete the last strategy."
                Utilities.sharedInstance.displayAlert(controller: controller!, title: title, message: message)
            } else {
                StrategyController.sharedInstance.remove(strategy: strategy)
                tableView?.beginUpdates()
                items.remove(at: indexPath.row)
                tableView?.deleteRows(at: [indexPath as IndexPath], with: .automatic)
                deleteItemIndexPath = nil
                tableView?.endUpdates()
            }
        }
    }
    
    override func textForCell(cell: ItemCell, item: AnyObject) -> ItemCell {
        let strategy = item as! Strategy
        let title = strategy.name
        let detailText = "Legs: \(strategy.legs)   Profit %: \(strategy.maxProfitPercentage)   Winning Probability: \(strategy.winningProbability)"
        cell.updateCell(title: title, detailText: detailText)
        return cell
    }
}
