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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureDefaultRealm()
        
        Utilities.sharedInstance.loadDataIfEmpty()
        
        let storyboard = StoryboardFactory().create(name: "Splash")
        let controller: SplashViewController = storyboard.instantiateInitialViewController() as! SplashViewController
        self.window?.rootViewController = controller
        
        StyleManager.setUpTheme()
        
        return true
    }
}
