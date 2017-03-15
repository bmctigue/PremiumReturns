//
//  BrokerTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class BrokerTableViewDataSource: ItemTableViewDataSource {
    
    override func updateDataSource() {
        items = BrokerController.sharedInstance.all()
    }
    
    override func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteItemIndexPath {
            let broker = items[indexPath.row]
            BrokerController.sharedInstance.remove(broker: broker as! Broker)
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
        let detailText = "commission: \(broker.commission)"
        cell.updateCell(title: title, detailText: detailText)
        return cell
    }
}
