//
//  EditStrategyTableViewController.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework

enum StrategySectionNames: String {
    case Data = "DATA"
}

enum StrategyFormFieldNames: String {
    case Name = "Strategy Name"
    case Legs = "Legs"
    case ProfitPercentage = "Profit Percentage"
    case WinningProbability = "Probability of Winning"
}

protocol EditStrategyTableViewControllerDelegate {
    func doneButtonPressed()
}

class EditStrategyTableViewController: FormViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    static let headerHeight: Float = 30.0
    static let fontName = "Avenir-Medium"
    static let fontSize: CGFloat = 12.0
    
    var strategyFormController: StrategyFormController?
    var strategy: Strategy?
    var delegate: EditStrategyTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.backgroundColor = UIColor.white
        self.cancelBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        self.doneBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        
        if strategy == nil {
            self.strategy = Strategy()
        }
        
        strategyFormController = StrategyFormController(form: form, controller: self, strategy: strategy!)
        strategyFormController?.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20
        
        updateInputFields(name: strategy!.name, legs: strategy!.legs, maxProfitPercentage: strategy!.maxProfitPercentage, winningProbability: strategy!.winningProbability)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func updateInputFields(name: String, legs: Int, maxProfitPercentage: Double, winningProbability: Double) {
        let nameRow: TextRow? = form.rowBy(tag: StrategyFormFieldNames.Name.rawValue)
        nameRow?.value = name
        nameRow?.updateCell()
        
        let legsRow: IntRow? = form.rowBy(tag: StrategyFormFieldNames.Legs.rawValue)
        legsRow?.value = legs
        legsRow?.updateCell()
        
        let profitPercentageRow: DecimalRow? = form.rowBy(tag: StrategyFormFieldNames.ProfitPercentage.rawValue)
        profitPercentageRow?.value = maxProfitPercentage
        profitPercentageRow?.updateCell()
        
        let winningProbabilityRow: DecimalRow? = form.rowBy(tag: StrategyFormFieldNames.WinningProbability.rawValue)
        winningProbabilityRow?.value = winningProbability
        winningProbabilityRow?.updateCell()
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        StrategyController.sharedInstance.save(strategy: strategy!)
        self.delegate?.doneButtonPressed()
        self.dismiss(animated: true, completion: nil)
    }
}
