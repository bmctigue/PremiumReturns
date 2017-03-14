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
    
    var items: [StrategyProtocol] = []
    var deleteItemIndexPath: NSIndexPath? = nil
    
    private(set) var tableViewDataSource: StrategyTableViewDataSource?
    private(set) var tableViewDelegate: StrategyTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView?.backgroundColor = UIColor.white
        self.addBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        self.tableViewDataSource = StrategyTableViewDataSource(tableView: tableView, controller: self) 
        self.tableViewDelegate = StrategyTableViewDelegate(tableView: tableView, controller: self)
    }
    
    func loadItems() -> [StrategyProtocol] {
        return StrategyController.sharedInstance.all()
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strategy = Strategy.forType(type: .Custom, name: "", legs: 0, maxProfitPercentage: 0, winningProbability: 0)
        RoutingController.sharedInstance.openEditStrategy(controller: self, strategy: strategy)
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}
