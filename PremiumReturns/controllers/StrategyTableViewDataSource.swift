//
//  StrategyTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class StrategyTableViewDataSource: NSObject {
    
    private(set) var items:[Strategy] = []
    var deleteItemIndexPath: NSIndexPath?
    var tableView: UITableView?
    var controller: UITableViewController?
    
    init(tableView: UITableView, controller: UITableViewController) {
        self.tableView = tableView
        self.controller = controller
        super.init()
        tableView.dataSource = self
    }
    
    func updateDataSource() {
        items = StrategyController.sharedInstance.all()
    }
    
    func confirmDelete(itemName: String) {
        let alert = UIAlertController(title: "Delete \(itemName)", message: "Are you sure you want to delete \(itemName)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteItem)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = controller!.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: controller!.view.bounds.size.width / 2.0, y: controller!.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        controller!.present(alert, animated: true, completion: nil)
    }
    
    private func handleDeleteItem(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteItemIndexPath {
            let strategy = items[indexPath.row]
            StrategyController.sharedInstance.remove(strategy: strategy)
            tableView?.beginUpdates()
            items.remove(at: indexPath.row)
            tableView?.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            deleteItemIndexPath = nil
            tableView?.endUpdates()
        }
    }
    
    private func cancelDeleteItem(alertAction: UIAlertAction!) {
        deleteItemIndexPath = nil
    }
}

extension StrategyTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath as IndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItemIndexPath = indexPath as NSIndexPath?
            let itemToDelete = items[indexPath.row]
            confirmDelete(itemName: itemToDelete.name)
        }
    }
}
