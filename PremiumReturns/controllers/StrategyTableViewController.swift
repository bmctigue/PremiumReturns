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
    
    var strategies: [StrategyProtocol] = []
    var deleteStrategyIndexPath: NSIndexPath? = nil
    
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteStrategyIndexPath = indexPath as NSIndexPath?
            let strategyToDelete = strategies[indexPath.row]
            confirmDelete(strategyName: strategyToDelete.name)
        }
    }
    
    func confirmDelete(strategyName: String) {
        let alert = UIAlertController(title: "Delete Strategy", message: "Are you sure you want to delete \(strategyName)?", preferredStyle: .actionSheet)

        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteStrategy)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteStrategy)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteStrategy(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteStrategyIndexPath {
            let strategy = strategies[indexPath.row]
            StrategyController.sharedInstance.remove(strategy: strategy as! Strategy)
            tableView.beginUpdates()
            strategies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteStrategyIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteStrategy(alertAction: UIAlertAction!) {
        deleteStrategyIndexPath = nil
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let strategy = Strategy.forType(type: .Custom, name: "", legs: 0, maxProfitPercentage: 0, winningProbability: 0)
        RoutingController.sharedInstance.openEditStrategy(controller: self, strategy: strategy)
    }
    
    func doneButtonPressed() {
        refreshData()
    }
}
