//
//  ItemTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class ItemTableViewDataSource: NSObject {
    
    var items:[AnyObject] = []
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
        // override me
    }
    
    func confirmDelete(itemName: String) {
        if items.count == 1 {
            let title = "Delete \(itemName)"
            let message = "Sorry, you can't delete the last entry."
            Utilities.sharedInstance.displayAlert(controller: controller!, title: title, message: message)
        } else {
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
    }
    
    func handleDeleteItem(alertAction: UIAlertAction!) {
        // override me
    }
    
    func cancelDeleteItem(alertAction: UIAlertAction!) {
        deleteItemIndexPath = nil
    }
    
    func textForCell(cell: ItemCell, item: AnyObject) -> ItemCell {
        return ItemCell()
    }
}

extension ItemTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        let item = items[indexPath.row]
        cell = textForCell(cell: cell, item: item)
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

