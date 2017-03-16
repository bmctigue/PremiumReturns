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
    case TDAmeritrade = "TDAmeritrade"
    case Custom = "Custom"
    static let brokerTypes = [TastyWorks,Custom]
}

protocol BrokerProtocol {
    var brokerId: String { get }
    var brokerType: String { get }
    var name: String { get }
    var commission: Double { get }
    func copyWithID() -> Broker
}

class Broker: Object, BrokerProtocol {
    dynamic var brokerId: String = NSUUID().uuidString
    dynamic var name: String = ""
    dynamic var brokerType: String = ""
    dynamic var commission: Double = 0.0
    
    override static func indexedProperties() -> [String] {
        return ["brokerId","name"]
    }
    
    override static func primaryKey() -> String? {
        return "brokerId"
    }
    
    class func forType(type: BrokerType, name: String, commission: Double) -> Broker {
        let attributesHash = ["brokerType": type.rawValue, "name": name, "commission": commission] as [String : Any]
        return Broker(value: attributesHash)
    }
    
    func copyWithID() -> Broker {
        let brokerType = BrokerController.sharedInstance.brokerTypeFor(broker: self)
        let newBroker = Broker.forType(type: brokerType, name: self.name, commission: self.commission)
        newBroker.brokerId = self.brokerId
        return newBroker
    }
}
