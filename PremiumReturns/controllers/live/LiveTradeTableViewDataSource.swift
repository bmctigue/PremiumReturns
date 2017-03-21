//
//  LiveTradeTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/21/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class LiveTradeTableViewDataSource: NSObject {
    
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
        items = TradeController.sharedInstance.all()
    }
    
    func textForCell(cell: ItemCell, item: AnyObject) -> ItemCell {
        let trade = item as! Trade
        let title = trade.ticker
        let formattedValue = Utilities.sharedInstance.formatOutput(value: trade.premium, showType: true)
        let detailText = "premium: \(formattedValue)"
        cell.updateCell(title: title, detailText: detailText)
        return cell
    }
}

extension LiveTradeTableViewDataSource: UITableViewDataSource {
    
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
}
