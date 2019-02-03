//
//  EditStrategyTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework

class EditStrategyTableViewController: FormViewController {
    
    static let headerHeight: Float = 30.0
    static let fontName = FontType.Primary.fontName
    static let fontSize: CGFloat = FontType.Primary.fontSize
    static let missingTitle = "Strategy Name"
    static let missingMessage = "Your stategy needs a unique name."
    
    lazy var strategyFormController = StrategyFormController(form: form, strategy: strategy)
    var strategy: Strategy!
    var delegate: EditItemTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.backgroundColor = UIColor.white
        setUpNavigationButtons()
        
        self.strategy = strategy == nil ? Strategy() : strategy
        
        strategyFormController.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20
        
        updateInputFields(name: strategy!.name, legs: strategy!.legs, maxProfitPercentage: strategy!.maxProfitPercentage)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func setUpNavigationButtons() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditStrategyTableViewController.cancelButtonPressed))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditStrategyTableViewController.doneButtonPressed))
        let topViewController = self.navigationController!.topViewController
        topViewController!.navigationItem.leftBarButtonItem = cancelBarButton
        topViewController!.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func updateInputFields(name: String, legs: Int, maxProfitPercentage: Int) {
        let nameRow: TextRow? = form.rowBy(tag: StrategyFormFieldNames.Name.rawValue)
        nameRow?.value = name
        nameRow?.updateCell()
        
        let legsRow: IntRow? = form.rowBy(tag: StrategyFormFieldNames.Legs.rawValue)
        legsRow?.value = legs
        legsRow?.updateCell()
        
        let profitPercentageRow: IntRow? = form.rowBy(tag: StrategyFormFieldNames.ProfitPercentage.rawValue)
        profitPercentageRow?.value = maxProfitPercentage
        profitPercentageRow?.updateCell()
    }

    @objc func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed() {
        let missingNameTitle = EditStrategyTableViewController.missingTitle
        let missingNameMessage = EditStrategyTableViewController.missingMessage
        let validationErrors = form.validate()
        if validationErrors.count == 0 && StrategyController.sharedInstance.isUnique(strategyId: strategy!.strategyId, name: strategy!.name) {
            StrategyController.sharedInstance.save(strategy: strategy!)
            self.delegate?.doneButtonPressed()
            self.dismiss(animated: true, completion: nil)
        } else {
            print("\(validationErrors)")
            Utilities.sharedInstance.displayAlert(controller: self, title: missingNameTitle, message: missingNameMessage)
        }
    }
}
