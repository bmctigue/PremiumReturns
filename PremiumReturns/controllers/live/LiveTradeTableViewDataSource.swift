//
//  LiveTradeTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/21/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Dwifft

class LiveTradeTableViewDataSource: ItemTableViewDataSource {
    
    var trades:[Trade] = []
    var diffCalculator: TableViewDiffCalculator<Int, Trade>?
    
    override init(tableView: UITableView, controller: UITableViewController) {
        super.init(tableView: tableView, controller: controller)
        tableView.dataSource = self
        self.diffCalculator = TableViewDiffCalculator(tableView: tableView)
    }
    
    override func updateDataSource() {
        trades = TradeController.sharedInstance.all()
        var mutable = [(Int, [Trade])]()
        mutable.append((0, trades))
        let sectionedValues = SectionedValues(mutable)
        self.diffCalculator?.sectionedValues = sectionedValues
    }
    
    override func handleDeleteItem(alertAction: UIAlertAction!) {
        if let indexPath = deleteItemIndexPath {
            let trade = trades[indexPath.row]
            TradeController.sharedInstance.remove(trade: trade)
            updateDataSource()
        }
    }
    
    func confirmDelete() {
        let alert = UIAlertController(title: "Delete a Trade", message: "Are you sure you want to delete this trade?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteItem)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteItem)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = controller!.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: controller!.view.bounds.size.width / 2.0, y: controller!.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        controller!.present(alert, animated: true, completion: nil)
    }
    
    override func textForCell(cell: ItemCell, item: AnyObject) -> ItemCell {
        let trade = item as! Trade
        let title = trade.ticker
        let formattedValue = Utilities.sharedInstance.formatOutput(value: trade.premium, showType: true)
        var formattedDateString = ""
        let formattedDate = Utilities.sharedInstance.dateFormatter.string(from: trade.date)
        formattedDateString = "  Date: \(formattedDate)"
        let detailText = "Premium: \(formattedValue)\(formattedDateString)"
        cell.updateCell(title: title, detailText: detailText)
        return cell
    }
}

extension LiveTradeTableViewDataSource {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diffCalculator?.numberOfObjects(inSection: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        guard let diffCalculator = self.diffCalculator else { return cell }
        let trade = diffCalculator.value(atIndexPath: indexPath)
        cell = textForCell(cell: cell, item: trade)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItemIndexPath = indexPath as NSIndexPath?
            confirmDelete()
        }
    }
}
