//
//  BrokerController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/6/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

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
    
    func save(broker: Broker) {
        try! realm.write {
            realm.add(broker, update: true)
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.delete(realm.objects(Broker.self))
        }
    }
    
    func resetBroker() -> Broker {
        let allBrokers = all()
        if allBrokers.count > 0 {
            return allBrokers.first!
        }
        return loadDefaultBroker()
    }
    
    func loadDefault() {
        removeAll()
        _ = loadDefaultBroker()
    }
    
    func loadDefaultBroker() -> Broker {
        let broker = Broker.forType(type: .TastyWorks, name: BrokerType.TastyWorks.rawValue, commission: 1.0)
        save(broker: broker)
        return broker
    }
}
