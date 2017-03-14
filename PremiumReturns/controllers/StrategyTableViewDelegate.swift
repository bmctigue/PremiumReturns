//
//  StrategyTableViewDelegate.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewDelegate: NSObject {
    
    private(set) var items:[Strategy] = []
    var tableView: UITableView?
    var controller: UITableViewController?
    
    init(tableView: UITableView, controller: UITableViewController) {
        self.tableView = tableView
        self.controller = controller
        self.items = StrategyController.sharedInstance.all()
        super.init()
        tableView.delegate = self
    }
}

extension StrategyTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let newItem = item.copyWithID()
        RoutingController.sharedInstance.openEditStrategy(controller: controller as! EditStrategyTableViewControllerDelegate, strategy: newItem)
    }
}
