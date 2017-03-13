//
//  TradeTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/22/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework

enum SectionNames: String {
    case Data = "TRADE"
    case Strategies = "STRATEGIES"
    case Returns = "RETURNS"
    case Costs = "COSTS"
}

enum FormFieldNames: String {
    case Strategy = "Select a Strategy"
    case Trade = "Expected Return"
    case ROC = "Return on Capital (%)"
    case Premium = "Premium"
    case MaxLoss = "Max Loss (BPR)"
    case Contracts = "Contracts"
    case Commissions = "Commissions"
    case DaysToExpiration = "Days To Expiration"
    case ReturnPerDay = "Return Per Day"
}

class TradeTableViewController: FormViewController, HelpViewControllerProtocol {
    
    @IBOutlet weak var resetBarButton: UIBarButtonItem!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    
    static let controllerTitle: String = "Returns"
    static let helpTitle: String = "Help"
    static let maxPremium: Double = 20.0
    static let maxLoss: Double = 1500.0
    static let contractsPremium: Double = 10
    static let headerHeight: Float = 30.0
    static let fontName = "Avenir-Medium"
    static let fontSize: CGFloat = 12.0
    static let helpViewDuration: Double = 0.75
    static let daysToExpiration: Int = 45
    
    var currentBroker: Broker?
    var currentStrategy: Strategy?
    var trade = TastyReturn(premium: 0, loss: 0, contracts: 1)
    var helpViewController: HelpViewController?
    var tradeFormController: TradeFormController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TradeTableViewController.controllerTitle
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        self.resetBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        self.helpBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        
        tradeFormController = TradeFormController(form: form, controller: self)
        tradeFormController?.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20

        addHelpView()
        currentBroker = BrokerController.sharedInstance.resetBroker()
        currentStrategy = StrategyController.sharedInstance.resetStrategy()
        trade = TradeController.sharedInstance.resetTrade(form: form, trade: trade) as! TastyReturn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tradeFormController?.refreshForm()
        TradeController.sharedInstance.updateInputFields(form: form, premium: trade.premium, loss: trade.loss, contracts: trade.contracts, days: trade.daysToExpiration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userHasOnboarded = UserDefaults.standard.bool(forKey: Constants.kUserHasOnboardedKey)
        if (!userHasOnboarded) {
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.showHelpView()
            }
            UserDefaults.standard.set(true, forKey: Constants.kUserHasOnboardedKey)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func addHelpView() {
        let helpStoryboard = StoryboardFactory().create(name: "Help")
        if let helpViewController = helpStoryboard.instantiateInitialViewController() as? HelpViewController {
            self.helpViewController = helpViewController
            self.helpViewController?.view.frame = self.view.bounds
            self.helpViewController?.view.alpha = 0
            self.helpViewController?.delegate = self
            self.view.addSubview((self.helpViewController?.view)!)
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        trade = TradeController.sharedInstance.resetTrade(form: form, trade: trade) as! TastyReturn
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        if helpViewController?.view.alpha == 0 {
            showHelpView()
        } else {
            closeButtonPressed()
        }
    }
    
    func showHelpView() {
        self.title = TradeTableViewController.helpTitle
        UIView.animate(withDuration: TradeTableViewController.helpViewDuration, animations: {
            self.helpViewController?.view.alpha = 1.0
        })
    }
    
    func closeButtonPressed() {
        self.title = TradeTableViewController.controllerTitle
        UIView.animate(withDuration: TradeTableViewController.helpViewDuration, animations: {
            self.helpViewController?.view.alpha = 0
        })
    }
}


