//
//  LiveTradeTableViewDataSource.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/21/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Dwifft

class LiveTradeTableViewDataSource: NSObject {
    
    var trades:[Trade] = []
    var deleteItemIndexPath: NSIndexPath?
    var tableView: UITableView?
    var controller: UITableViewController?
    var diffCalculator: TableViewDiffCalculator<Int, Trade>?
    
    init(tableView: UITableView, controller: UITableViewController) {
        self.tableView = tableView
        self.controller = controller
        super.init()
        tableView.dataSource = self
        self.diffCalculator = TableViewDiffCalculator(tableView: tableView)
    }
    
    func updateDataSource() {
        trades = TradeController.sharedInstance.all()
        var mutable = [(Int, [Trade])]()
        mutable.append((0, trades))
        let sectionedValues = SectionedValues(mutable)
        self.diffCalculator?.sectionedValues = sectionedValues
    }
    
    func textForCell(cell: ItemCell, item: AnyObject) -> ItemCell {
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

extension LiveTradeTableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diffCalculator?.numberOfObjects(inSection: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath as IndexPath) as! ItemCell
        guard let diffCalculator = self.diffCalculator else { return cell }
        let trade = diffCalculator.value(atIndexPath: indexPath)
        cell = textForCell(cell: cell, item: trade)
        return cell
    }
}
