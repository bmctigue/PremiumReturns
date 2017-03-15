//
//  StrategyTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/9/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewController: ItemTableViewController, EditItemTableViewControllerDelegate {
    
    private(set) var tableViewDataSource: StrategyTableViewDataSource?
    private(set) var tableViewDelegate: StrategyTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDataSource = StrategyTableViewDataSource(tableView: tableView, controller: self)
        self.tableView.dataSource = tableViewDataSource
        self.tableViewDelegate = StrategyTableViewDelegate(tableView: tableView, controller: self)
        self.tableView.delegate = tableViewDelegate
        refreshData()
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        tableViewDelegate?.addButtonPressed()
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}
