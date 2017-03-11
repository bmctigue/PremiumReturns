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
        let items = realm.objects(Strategy.self)
        if items.count == 0 {
            return [Strategy]()
        }
        return Array(items)
    }
    
    func find(key: String) -> Strategy? {
        return realm.object(ofType: Strategy.self, forPrimaryKey: key)
    }
    
    func save(strategy: Strategy) {
        try! realm.write {
            realm.add(strategy, update: true)
        }
    }
    
    func loadDefault() {
        defaultStrategy()
        _ = Strategy.forType(type: .IronFly, name: StrategyType.IronFly.rawValue, legs: 4, maxProfitPercentage: 0.10, winningProbability: 0.70)
        _ = Strategy.forType(type: .VerticalSpread, name: StrategyType.VerticalSpread.rawValue, legs: 2, maxProfitPercentage: 0.50, winningProbability: 0.90)
        _ = Strategy.forType(type: .Straddle, name: StrategyType.Straddle.rawValue, legs: 2, maxProfitPercentage: 0.25, winningProbability: 0.75)
        _ = Strategy.forType(type: .Strangle, name: StrategyType.Strangle.rawValue, legs: 2, maxProfitPercentage: 0.50, winningProbability: 0.90)
        _ = Strategy.forType(type: .RatioSpread, name: StrategyType.RatioSpread.rawValue, legs: 3, maxProfitPercentage: 0.25, winningProbability: 0.75)
        _ = Strategy.forType(type: .JadeLizard, name: StrategyType.JadeLizard.rawValue, legs: 3, maxProfitPercentage: 0.50, winningProbability: 0.90)
    }
    
    func defaultStrategy() {
        _ = Strategy.forType(type: .IronCondor, name: StrategyType.IronCondor.rawValue, legs: 4, maxProfitPercentage: 0.50, winningProbability: 0.90)
    }
}
