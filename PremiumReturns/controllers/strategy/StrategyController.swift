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
        removeAll()
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
        let strategy = Strategy.forType(.IronCondor, name: StrategyType.IronCondor.rawValue, legs: 4, maxProfitPercentage: 50, pop: 90)
        Defaults[.strategy] = strategy.strategyId
        save(strategy: strategy)
        return strategy
    }
    
    func loadDefault() {
        removeAll()
        _ = loadDefaultStrategy()
        let ironFly = Strategy.forType(.IronFly, name: StrategyType.IronFly.rawValue, legs: 4, maxProfitPercentage: 25, pop: 65)
        let verticalSpread = Strategy.forType(.VerticalSpread, name: StrategyType.VerticalSpread.rawValue, legs: 2, maxProfitPercentage: 50, pop: 90)
        let straddle = Strategy.forType(.Straddle, name: StrategyType.Straddle.rawValue, legs: 2, maxProfitPercentage: 25, pop: 75)
        let strangle = Strategy.forType(.Strangle, name: StrategyType.Strangle.rawValue, legs: 2, maxProfitPercentage: 50, pop: 90)
        let ratioSpread = Strategy.forType(.RatioSpread, name: StrategyType.RatioSpread.rawValue, legs: 3, maxProfitPercentage: 25, pop: 75)
        let jadeLizard = Strategy.forType(.JadeLizard, name: StrategyType.JadeLizard.rawValue, legs: 3, maxProfitPercentage: 50, pop: 90)
        
        save(strategy: ironFly)
        save(strategy: verticalSpread)
        save(strategy: straddle)
        save(strategy: strangle)
        save(strategy: ratioSpread)
        save(strategy: jadeLizard)
    }
}
