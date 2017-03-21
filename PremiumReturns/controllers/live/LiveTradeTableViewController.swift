//
//  LiveTradeTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/21/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class LiveTradeTableViewController: UITableViewController {

    private(set) var tableViewDataSource: LiveTradeTableViewDataSource?
    private(set) var tableViewDelegate: LiveTradeTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.white
        self.tableViewDataSource = LiveTradeTableViewDataSource(tableView: tableView, controller: self)
        self.tableView.dataSource = tableViewDataSource
        self.tableViewDelegate = LiveTradeTableViewDelegate(tableView: tableView, controller: self)
        self.tableView.delegate = tableViewDelegate
        refreshData()
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableViewDelegate?.updateDataSource()
        self.tableView.reloadData()
    }

}
