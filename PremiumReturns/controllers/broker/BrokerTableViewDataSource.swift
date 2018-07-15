//
//  BrokerTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

final class BrokerTableViewDataSource: ItemTableViewDataSource {
    
    override func updateDataSource() {
        items = BrokerController.sharedInstance.all()
    }
    
    override func handleDeleteItem(alertAction: UIAlertAction!) {
        if let indexPath = deleteItemIndexPath {
            let broker = items[indexPath.row] as! Broker
            BrokerController.sharedInstance.remove(broker: broker)
            tableView?.beginUpdates()
            items.remove(at: indexPath.row)
            tableView?.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteItemIndexPath = nil
            tableView?.endUpdates()
        }
    }
    
    override func textForCell(cell: ItemCell, item: AnyObject) -> ItemCell {
        let broker = item as! Broker
        let title = broker.name
        let formattedValue = Utilities.sharedInstance.formatOutput(value: broker.commission, showType: true)
        let detailText = "commission: \(formattedValue)"
        cell.updateCell(title: title, detailText: detailText)
        return cell
    }
}
