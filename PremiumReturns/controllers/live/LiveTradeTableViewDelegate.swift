//
//  LiveTradeTableViewDelegate.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/21/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class LiveTradeTableViewDelegate: NSObject {
    
    private(set) var items:[Trade] = []
    var tableView: UITableView?
    var controller: UITableViewController?
    
    init(tableView: UITableView, controller: UITableViewController) {
        self.tableView = tableView
        self.controller = controller
        self.items = TradeController.sharedInstance.all()
        super.init()
        tableView.delegate = self
    }
    
    func updateDataSource() {
        items = TradeController.sharedInstance.all()
    }
}

extension LiveTradeTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
//        RoutingController.sharedInstance.openEditBroker(controller: controller as! EditItemTableViewControllerDelegate, broker: newItem)
    }
}
