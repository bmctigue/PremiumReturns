//
//  LiveTradeTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/21/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import RealmSwift

class LiveTradeTableViewController: UITableViewController {
    
    static let controllerTitle: String = "Live Trades"
    
    let realm: Realm = try! Realm()
    var notificationToken: NotificationToken? = nil

    private(set) var tableViewDataSource: LiveTradeTableViewDataSource?
    private(set) var tableViewDelegate: LiveTradeTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LiveTradeTableViewController.controllerTitle
        self.tableView?.backgroundColor = UIColor.white
        self.tableViewDataSource = LiveTradeTableViewDataSource(tableView: tableView, controller: self)
        self.tableView.dataSource = tableViewDataSource
        self.tableViewDelegate = LiveTradeTableViewDelegate(tableView: tableView, controller: self)
        self.tableView.delegate = tableViewDelegate
        
        notificationToken = realm.addNotificationBlock { notification, realm in
            self.refreshData()
        }
        
        refreshData()
    }
    
    func refreshData() {
        self.tableViewDataSource?.updateDataSource()
        self.tableViewDelegate?.updateDataSource()
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        notificationToken?.stop()
    }
}
