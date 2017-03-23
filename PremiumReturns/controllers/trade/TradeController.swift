//
//  TradeController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/13/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

final class TradeController {
    
    static let sharedInstance = TradeController.init()
    
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func all() -> [Trade] {
        let items = realm.objects(Trade.self).sorted(byKeyPath: "date", ascending: false)
        if items.count == 0 {
            return [Trade]()
        }
        return Array(items)
    }
    
    func find(key: String) -> Trade? {
        return realm.object(ofType: Trade.self, forPrimaryKey: key)
    }
    
    func save(trade: Trade) {
        let copiedTrade = trade.copyWithPremium()
        try! realm.write {
            realm.add(copiedTrade, update: true)
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.delete(realm.objects(Trade.self))
        }
    }
}


