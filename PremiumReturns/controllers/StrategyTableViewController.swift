//
//  StrategyTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/9/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewController: UITableViewController, EditStrategyTableViewControllerDelegate {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    private(set) var tableViewDataSource: StrategyTableViewDataSource?
    private(set) var tableViewDelegate: StrategyTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.white
        self.addBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        self.tableViewDataSource = StrategyTableViewDataSource(tableView: tableView, controller: self) 
        self.tableViewDelegate = StrategyTableViewDelegate(tableView: tableView, controller: self)
        self.tableView.dataSource = tableViewDataSource
        self.tableView.delegate = tableViewDelegate
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.tableViewDelegate?.addButtonPressed()
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}
