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
    case TDAmeritrade = "TD Ameritrade"
    case Custom = "Custom"
    static let brokerTypes = [TastyWorks, TDAmeritrade, Custom]
}

protocol BrokerProtocol {
    var brokerId: String { get }
    var brokerType: String { get }
    var name: String { get }
    var commission: Double { get }
    func copyWithID() -> Broker
}

final class Broker: Object, BrokerProtocol {
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
    
    func brokerTypeFor() -> BrokerType {
        var brokerType: BrokerType = .Custom
        let brokerTypeString = self.brokerType
        switch brokerTypeString {
        case BrokerType.TastyWorks.rawValue:
            brokerType = .TastyWorks
        default:
            brokerType = .Custom
        }
        return brokerType
    }
    
    func copyWithID() -> Broker {
        let newBroker = Broker.forType(type: self.brokerTypeFor(), name: self.name, commission: self.commission)
        newBroker.brokerId = self.brokerId
        return newBroker
    }
}
