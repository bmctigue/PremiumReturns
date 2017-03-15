//
//  StrategyTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/9/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewController: ItemTableViewController {
    
    private(set) var tableViewDelegate: StrategyTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDelegate = StrategyTableViewDelegate(tableView: tableView, controller: self)
        self.tableView.delegate = tableViewDelegate
        refreshData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        tableViewDelegate?.addButtonPressed()
    }
}
