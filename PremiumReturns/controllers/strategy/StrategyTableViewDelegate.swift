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
    weak var tableView: UITableView?
    weak var controller: UITableViewController?
    
    init(tableView: UITableView, controller: UITableViewController) {
        self.tableView = tableView
        self.controller = controller
        self.items = StrategyController.sharedInstance.all()
        super.init()
        tableView.delegate = self
    }
    
    func updateDataSource() {
        items = StrategyController.sharedInstance.all()
    }
    
    func addButtonPressed() {
        let strategy = Strategy.forType(.Custom, name: "", legs: 0, maxProfitPercentage: 0, pop: 0)
        RoutingController.sharedInstance.openEditStrategy(controller: controller as! EditItemTableViewControllerDelegate, strategy: strategy)
    }
}

extension StrategyTableViewDelegate: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row]
        let newItem = item.copyWithID()
        RoutingController.sharedInstance.openEditStrategy(controller: controller as! EditItemTableViewControllerDelegate, strategy: newItem)
    }
}
