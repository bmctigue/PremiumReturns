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

final class ModelControllerUtilities: NSObject {
    
    lazy var modelController = ModelController()
    
    static let sharedInstance = ModelControllerUtilities()
    private override init() {}
    
    func refreshAppData() {
        clearAllModelControllers()
        loadAllModelControllers()
    }
    
    func clearAllModelControllers() {
        modelController.clear()
    }
    
    func loadAllModelControllers() {
        StrategyController.sharedInstance.loadDefault()
        BrokerController.sharedInstance.loadDefault()
    }
}
