//
//  RoutingController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

final class RoutingController: NSObject {
    
    static let sharedInstance = RoutingController.init()
    
    func openEditStrategy(controller: EditStrategyTableViewControllerDelegate, strategy: Strategy) {
        let storyboard = StoryboardFactory().create(name: "Strategy")
        let editStrategyController: EditStrategyTableViewController = storyboard.instantiateViewController(withIdentifier: "EditStrategyTableViewController") as! EditStrategyTableViewController
        editStrategyController.strategy = strategy
        editStrategyController.delegate = controller
        editStrategyController.title = strategy.name
        let navigationController = UINavigationController(rootViewController: editStrategyController)
        navigationController.navigationBar.isTranslucent = false
        let presentingController = controller as! UIViewController
        presentingController.present(navigationController, animated: true, completion: nil)
    }
    
//    func openEditBroker(controller: EditBrokerTableViewControllerDelegate, broker: broker) {
//        let storyboard = StoryboardFactory().create(name: "Broker")
//        let editBrokerController: EditBrokerTableViewController = storyboard.instantiateViewController(withIdentifier: "EditBrokerTableViewController") as! EditBrokerTableViewController
//        editBrokerController.strategy = broker
//        editBrokerController.delegate = controller
//        editBrokerController.title = broker.name
//        let navigationController = UINavigationController(rootViewController: editBrokerController)
//        navigationController.navigationBar.isTranslucent = false
//        let presentingController = controller as! UIViewController
//        presentingController.present(navigationController, animated: true, completion: nil)
//    }
}
