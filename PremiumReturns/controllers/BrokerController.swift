//
//  BrokerController.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 3/6/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import Foundation
import RealmSwift

final class BrokerController {
    
    static let sharedInstance = BrokerController.init()
    
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func all() -> [Broker] {
        let items = realm.objects(Broker.self)
        if items.count == 0 {
            return [Broker]()
        }
        return Array(items)
    }
    
    func find(key: String) -> Broker? {
        return realm.object(ofType: Broker.self, forPrimaryKey: key)
    }
    
    func loadDefault() {
        defaultStrategy()
    }
    
    func defaultStrategy() {
        _ = Broker.forType(type: .TastyWorks, name: BrokerType.TastyWorks.rawValue, commission: 1.0)
    }
}
