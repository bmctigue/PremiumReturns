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
    var name: String { get }
    var legs: Int { get }
    var maxProfitPercentage: Double { get }
    var winningProbability: Double { get }
}

class Strategy: Object, StrategyProtocol {
    dynamic var strategyId: String = NSUUID().uuidString
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
        switch type {
        case .IronCondor:
            return IronCondor.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .IronFly:
            return IronFly.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .VerticalSpread:
            return VerticalSpread.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .Straddle:
            return Straddle.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .Strangle:
            return Strangle.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .RatioSpread:
            return RatioSpread.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .JadeLizard:
            return JadeLizard.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        case .Custom:
            return Custom.create(name: name, legs: legs, maxProfitPercentage: maxProfitPercentage, winningProbability: winningProbability)
        }
    }
    
    class func copyForClass(strategy: StrategyProtocol) -> Strategy {
        var strategyType: StrategyType = .Custom
        switch String(describing: strategy.self) {
        case "IronCondor":
            strategyType = .IronCondor
        case "IronFly":
            strategyType = .IronFly
        case "VerticalSpread":
            strategyType = .VerticalSpread
        case "Straddle":
            strategyType = .Straddle
        case "Strangle":
            strategyType = .Strangle
        case "RatioSpread":
            strategyType = .RatioSpread
        case "JadeLizard":
            strategyType = .JadeLizard
        default:
            strategyType = .Custom
        }
        return Strategy.forType(type: strategyType, name: strategy.name, legs: strategy.legs, maxProfitPercentage: strategy.maxProfitPercentage, winningProbability: strategy.winningProbability)
    }
    
    class func create(name: String, legs: Int, maxProfitPercentage: Double, winningProbability: Double) -> Strategy {
        let strategy = Strategy(value: ["name": name, "legs": legs, "maxProfitPercentage": maxProfitPercentage, "winningProbability": winningProbability])
        let realm = try! Realm()
        try! realm.write {
            realm.add(strategy)
        }
        return strategy
    }
}

final class IronCondor: Strategy {}
final class IronFly: Strategy {}
final class VerticalSpread: Strategy {}
final class Straddle: Strategy {}
final class Strangle: Strategy {}
final class RatioSpread: Strategy {}
final class JadeLizard: Strategy {}
final class Custom: Strategy {}

