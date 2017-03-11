//
//  StrategyTableViewController.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 3/9/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewController: UITableViewController, EditStrategyTableViewControllerDelegate {
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var strategies: [StrategyProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView?.backgroundColor = UIColor.white
        self.addBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        
        strategies = loadStrategies()
    }
    
    func loadStrategies() -> [StrategyProtocol] {
        return StrategyController.sharedInstance.all()
    }
    
    func refreshData() {
        strategies = loadStrategies()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strategies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StrategyCell", for: indexPath)
        let strategy = strategies[indexPath.row]
        cell.textLabel?.text = strategy.name
        cell.detailTextLabel?.text = "Legs: \(strategy.legs)   Profit %: \(strategy.maxProfitPercentage)   Winning Probability: \(strategy.winningProbability)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strategy = strategies[indexPath.row]
        let newStrategy = strategy.copyWithID()
        RoutingController.sharedInstance.openEditStrategy(controller: self, strategy: newStrategy)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strategy = Strategy.forType(type: .Custom, name: "", legs: 0, maxProfitPercentage: 0, winningProbability: 0)
        RoutingController.sharedInstance.openEditStrategy(controller: self, strategy: strategy)
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}
