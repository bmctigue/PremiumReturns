//
//  StrategyController.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 3/4/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import Foundation
import RealmSwift

final class StrategyController {
    
    static let sharedInstance = StrategyController.init()
    
    let realm: Realm
    
    init() {
        self.realm = try! Realm()
    }
    
    func all() -> [Strategy] {
        return Array(realm.objects(Strategy.self))
    }
    
    func find(key: String) -> Strategy? {
        return realm.object(ofType: Strategy.self, forPrimaryKey: key)
    }
    
    func find(name: String) -> [Strategy] {
        let predicate = NSPredicate(format: "name = %@", name)
        return Array(realm.objects(Strategy.self).filter(predicate))
    }
    
    func save(strategy: Strategy) {
        try! realm.write {
            realm.add(strategy, update: true)
        }
    }
    
    func remove(strategy: Strategy) {
        try! realm.write {
            realm.delete(strategy)
        }
    }
    
    func removeAll() {
        try! realm.write {
            realm.delete(realm.objects(Strategy.self))
        }
    }
    
    func strategyTypeFor(strategy: Strategy) -> StrategyType {
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
        return strategyType
    }
    
    func loadDefault() {
        removeAll()
        let ironCondor = Strategy.forType(type: .IronCondor, name: StrategyType.IronCondor.rawValue, legs: 4, maxProfitPercentage: 0.50, winningProbability: 0.90)
        StrategyController.sharedInstance.save(strategy: ironCondor)
        let ironFly = Strategy.forType(type: .IronFly, name: StrategyType.IronFly.rawValue, legs: 4, maxProfitPercentage: 0.25, winningProbability: 0.65)
        StrategyController.sharedInstance.save(strategy: ironFly)
        let verticalSpread = Strategy.forType(type: .VerticalSpread, name: StrategyType.VerticalSpread.rawValue, legs: 2, maxProfitPercentage: 0.50, winningProbability: 0.90)
        StrategyController.sharedInstance.save(strategy: verticalSpread)
        let straddle = Strategy.forType(type: .Straddle, name: StrategyType.Straddle.rawValue, legs: 2, maxProfitPercentage: 0.25, winningProbability: 0.75)
        StrategyController.sharedInstance.save(strategy: straddle)
        let strangle = Strategy.forType(type: .Strangle, name: StrategyType.Strangle.rawValue, legs: 2, maxProfitPercentage: 0.50, winningProbability: 0.90)
        StrategyController.sharedInstance.save(strategy: strangle)
        let ratioSpread = Strategy.forType(type: .RatioSpread, name: StrategyType.RatioSpread.rawValue, legs: 3, maxProfitPercentage: 0.25, winningProbability: 0.75)
        StrategyController.sharedInstance.save(strategy: ratioSpread)
        let jadeLizard = Strategy.forType(type: .JadeLizard, name: StrategyType.JadeLizard.rawValue, legs: 3, maxProfitPercentage: 0.50, winningProbability: 0.90)
        StrategyController.sharedInstance.save(strategy: jadeLizard)
    }
}
