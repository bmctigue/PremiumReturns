//
//  AppDelegate.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/20/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        configureDefaultRealm()
        
        loadDataIfEmpty()
        
        let storyboard = StoryboardFactory().create(name: "Splash")
        let controller: SplashViewController = storyboard.instantiateInitialViewController() as! SplashViewController
        self.window?.rootViewController = controller
        
        UITabBar.appearance().tintColor = UIColor(hexString: Constants.barButtonTintColor)
        
        return true
    }
    
    func loadDataIfEmpty() {
        if StrategyController.sharedInstance.all().count == 0 {
            StrategyController.sharedInstance.loadDefault()
        }
        
        if BrokerController.sharedInstance.all().count == 0 {
            BrokerController.sharedInstance.loadDefault()
        }
    }
}

