//
//  Broker.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/6/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import Foundation
import RealmSwift

enum BrokerType: String {
    case TastyWorks = "TastyWorks"
    static let brokerTypes = [TastyWorks]
    static let brokerTypesHash = [TastyWorks.rawValue:TastyWorks]
}

protocol BrokerProtocol {
    var brokerId: String { get }
    var name: String { get }
    var commission: Double { get }
}

class Broker: Object, BrokerProtocol {
    dynamic var brokerId: String = NSUUID().uuidString
    dynamic var name: String = ""
    dynamic var commission: Double = 0.0
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    class func forType(type: BrokerType, name: String, commission: Double) -> Broker {
        switch type {
        case .TastyWorks:
            return TastyWorks.create(name: name, commission: commission)
        }
    }
    
    class func create(name: String, commission: Double) -> Broker {
        let broker = Broker(value: ["name": name, "commission": commission])
        let realm = try! Realm()
        try! realm.write {
            realm.add(broker)
        }
        return broker
    }
}

final class TastyWorks: Broker {}
