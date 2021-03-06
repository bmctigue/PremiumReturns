//
//  Strategy.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import Foundation
import RealmSwift

enum StrategyType: String {
    case IronCondor = "Iron Condor"
    case IronFly = "Iron Fly"
    case VerticalSpread = "Vertical Spread"
    case Straddle = "Straddle"
    case Strangle = "Strangle"
    case RatioSpread = "Ratio Spread"
    case JadeLizard = "Jade Lizard"
    case Custom = "Custom"
    static let strategyTypes = [IronCondor, IronFly, VerticalSpread, Straddle, Strangle, RatioSpread, JadeLizard, Custom]
}

protocol StrategyProtocol {
    var strategyId: String { get }
    var strategyType: String { get }
    var name: String { get }
    var legs: Int { get }
    var maxProfitPercentage: Int { get }
    var pop: Int { get }
    func copyWithID() -> Strategy
}

final class Strategy: Object, StrategyProtocol {
    @objc dynamic var strategyId: String = NSUUID().uuidString
    @objc dynamic var strategyType: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var legs: Int = 0
    @objc dynamic var maxProfitPercentage: Int = 0
    @objc dynamic var pop: Int = 0
    
    override static func indexedProperties() -> [String] {
        return ["strategyId", "name"]
    }
    
    override static func primaryKey() -> String? {
        return "strategyId"
    }
    
    class func forType(_ type: StrategyType, name: String, legs: Int, maxProfitPercentage: Int, pop: Int) -> Strategy {
        let attributesHash = ["strategyType": type.rawValue, "name": name, "legs": legs, "maxProfitPercentage": maxProfitPercentage, "pop": pop] as [String : Any]
        return Strategy(value: attributesHash)
    }
    
    func strategyTypeForStrategy() -> StrategyType {
        var strategyType: StrategyType = .Custom
        let strategyTypeString = self.strategyType
        switch strategyTypeString {
        case StrategyType.IronCondor.rawValue:
            strategyType = .IronCondor
        case StrategyType.IronFly.rawValue:
            strategyType = .IronFly
        case StrategyType.VerticalSpread.rawValue:
            strategyType = .VerticalSpread
        case StrategyType.Straddle.rawValue:
            strategyType = .Straddle
        case StrategyType.Strangle.rawValue:
            strategyType = .Strangle
        case StrategyType.RatioSpread.rawValue:
            strategyType = .RatioSpread
        case StrategyType.JadeLizard.rawValue:
            strategyType = .JadeLizard
        default:
            strategyType = .Custom
        }
        return strategyType
    }
    
    func copyWithID() -> Strategy {
        let newStrategy = Strategy.forType(self.strategyTypeForStrategy(), name: self.name, legs: self.legs, maxProfitPercentage: self.maxProfitPercentage, pop: self.pop)
        newStrategy.strategyId = self.strategyId
        return newStrategy
    }
}

