//
//  ModelControllerUtilities.swift
//  BiasBike
//
//  Created by Bruce McTigue on 9/15/16.
//  Copyright © 2016 tiguer. All rights reserved.
//

import Foundation

protocol ModelControllerUtilitiesProtocol {
    func clearAllModelControllers()
    func loadAllModelControllers()
    func saveAllModelControllers()
}

final class ModelControllerUtilities {
    
    static let sharedInstance = ModelControllerUtilities.init()
    
    func refreshAppData() {
        clearAllModelControllers()
        loadAllModelControllers()
    }
    
    func clearAllModelControllers() {
        ModelController.sharedInstance.clear()
    }
    
    func loadAllModelControllers() {
        StrategyController.sharedInstance.loadDefault()
        BrokerController.sharedInstance.loadDefault()
    }
}
