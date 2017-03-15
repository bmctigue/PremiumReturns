//
//  ItemTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

protocol EditItemTableViewControllerDelegate {
    func doneButtonPressed()
}

class ItemTableViewController: UITableViewController, EditItemTableViewControllerDelegate {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    private(set) var tableViewDataSource: ItemTableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.white
        self.addBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        self.tableViewDataSource = StrategyTableViewDataSource(tableView: tableView, controller: self)
        self.tableView.dataSource = tableViewDataSource
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableView.reloadData()
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}
