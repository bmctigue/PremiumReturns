//
//  Strategy.swift
//  TastyReturns
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
    static let strategyTypes = [IronCondor,IronFly,VerticalSpread,Straddle,Strangle,RatioSpread,JadeLizard,Custom]
    static let strategyTypesHash = [IronCondor.rawValue:IronCondor,IronFly.rawValue:IronFly,VerticalSpread.rawValue:VerticalSpread,Straddle.rawValue:Straddle,Strangle.rawValue:Strangle,RatioSpread.rawValue:RatioSpread,JadeLizard.rawValue:JadeLizard,Custom.rawValue:Custom]
}

protocol StrategyProtocol {
    var strategyId: String { get }
    var strategyType: String { get }
    var name: String { get }
    var legs: Int { get }
    var maxProfitPercentage: Double { get }
    var winningProbability: Double { get }
    func copyWithID() -> Strategy
}

class Strategy: Object, StrategyProtocol {
    dynamic var strategyId: String = NSUUID().uuidString
    dynamic var strategyType: String = ""
    dynamic var name: String = ""
    dynamic var legs: Int = 0
    dynamic var maxProfitPercentage: Double = 0.0
    dynamic var winningProbability: Double = 0.0
    
    override static func indexedProperties() -> [String] {
        return ["strategyId","name"]
    }
    
    override static func primaryKey() -> String? {
        return "strategyId"
    }
    
    class func forType(type: StrategyType,name: String, legs: Int, maxProfitPercentage: Double, winningProbability: Double) -> Strategy {
        let attributesHash = ["strategyType": type.rawValue, "name": name, "legs": legs, "maxProfitPercentage": maxProfitPercentage, "winningProbability": winningProbability] as [String : Any]
        return Strategy(value: attributesHash)
    }
    
    func copyWithID() -> Strategy {
        let strategyType = StrategyController.sharedInstance.strategyTypeFor(strategy: self)
        let newStrategy = Strategy.forType(type: strategyType, name: self.name, legs: self.legs, maxProfitPercentage: self.maxProfitPercentage, winningProbability: self.winningProbability)
        newStrategy.strategyId = self.strategyId
        return newStrategy
    }
}

