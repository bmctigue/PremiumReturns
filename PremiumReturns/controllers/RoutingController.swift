//
//  RoutingController.swift
//  TastyReturns
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
        let presentingController = controller as! UIViewController
        presentingController.present(editStrategyController, animated: true, completion: nil)
    }
}
