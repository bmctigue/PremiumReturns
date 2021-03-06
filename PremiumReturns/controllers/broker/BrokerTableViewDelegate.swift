//
//  BrokerTableViewDelegate.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class BrokerTableViewDelegate: NSObject {
    
    private(set) var items:[Broker] = []
    var tableView: UITableView?
    var controller: UITableViewController?
    
    init(tableView: UITableView, controller: UITableViewController) {
        self.tableView = tableView
        self.controller = controller
        self.items = BrokerController.sharedInstance.all()
        super.init()
        tableView.delegate = self
    }
    
    func updateDataSource() {
        items = BrokerController.sharedInstance.all()
    }
    
    func addButtonPressed() {
        let broker = Broker.forType(type: .Custom, name: "", commission: 1.0)
        RoutingController.sharedInstance.openEditBroker(controller: controller as! EditItemTableViewControllerDelegate, broker: broker)
    }
}

extension BrokerTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row]
        let newItem = item.copyWithID()
        RoutingController.sharedInstance.openEditBroker(controller: controller as! EditItemTableViewControllerDelegate, broker: newItem)
    }
}
