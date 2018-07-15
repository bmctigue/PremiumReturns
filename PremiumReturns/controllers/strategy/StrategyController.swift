//
//  StrategyController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/4/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyUserDefaults

final class StrategyController {
    
    static let sharedInstance = StrategyController()
    
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
    
    func isUnique(strategyId: String, name: String) -> Bool {
        let strategies = self.find(name: name)
        if strategies.isEmpty {
            return true
        }
        let strategy = strategies.first!
        return strategy.strategyId == strategyId
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
    
    func resetStrategy() -> Strategy {
        let allStrategies = all()
        if allStrategies.count > 0 {
            if Defaults.hasKey(.strategy) {
                if let strategy = StrategyController.sharedInstance.find(key: Defaults[.strategy]) {
                    return strategy
                }
            }
            Defaults[.strategy] = allStrategies.first!.strategyId
            return allStrategies.first!
        }
        return loadDefaultStrategy()
    }
    
    func loadDefaultStrategy() -> Strategy {
        let strategy = Strategy.forType(type: .IronCondor, name: StrategyType.IronCondor.rawValue, legs: 4, maxProfitPercentage: 50, pop: 90)
        Defaults[.strategy] = strategy.strategyId
        save(strategy: strategy)
        return strategy
    }
    
    func loadDefault() {
        removeAll()
        _ = loadDefaultStrategy()
        let ironFly = Strategy.forType(type: .IronFly, name: StrategyType.IronFly.rawValue, legs: 4, maxProfitPercentage: 25, pop: 65)
        StrategyController.sharedInstance.save(strategy: ironFly)
        let verticalSpread = Strategy.forType(type: .VerticalSpread, name: StrategyType.VerticalSpread.rawValue, legs: 2, maxProfitPercentage: 50, pop: 90)
        StrategyController.sharedInstance.save(strategy: verticalSpread)
        let straddle = Strategy.forType(type: .Straddle, name: StrategyType.Straddle.rawValue, legs: 2, maxProfitPercentage: 25, pop: 75)
        StrategyController.sharedInstance.save(strategy: straddle)
        let strangle = Strategy.forType(type: .Strangle, name: StrategyType.Strangle.rawValue, legs: 2, maxProfitPercentage: 50, pop: 90)
        StrategyController.sharedInstance.save(strategy: strangle)
        let ratioSpread = Strategy.forType(type: .RatioSpread, name: StrategyType.RatioSpread.rawValue, legs: 3, maxProfitPercentage: 25, pop: 75)
        StrategyController.sharedInstance.save(strategy: ratioSpread)
        let jadeLizard = Strategy.forType(type: .JadeLizard, name: StrategyType.JadeLizard.rawValue, legs: 3, maxProfitPercentage: 50, pop: 90)
        StrategyController.sharedInstance.save(strategy: jadeLizard)
    }
}
