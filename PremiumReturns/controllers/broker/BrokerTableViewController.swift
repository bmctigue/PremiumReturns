//
//  BrokerTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/9/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class BrokerTableViewController: ItemTableViewController, EditItemTableViewControllerDelegate {
    
    private(set) var tableViewDataSource: ItemTableViewDataSource?
    private(set) var tableViewDelegate: BrokerTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDataSource = BrokerTableViewDataSource(tableView: tableView, controller: self)
        self.tableView.dataSource = tableViewDataSource
        self.tableViewDelegate = BrokerTableViewDelegate(tableView: tableView, controller: self)
        self.tableView.delegate = tableViewDelegate
        refreshData()
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableViewDelegate?.updateDataSource()
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        tableViewDelegate?.addButtonPressed()
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}

