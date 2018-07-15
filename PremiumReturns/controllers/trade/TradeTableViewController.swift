//
//  TradeTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/22/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import SwiftyUserDefaults

class TradeTableViewController: FormViewController, HelpViewControllerProtocol {
    
    @IBOutlet weak var resetBarButton: UIBarButtonItem!
    @IBOutlet weak var helpBarButton: UIBarButtonItem!
    
    static let controllerTitle: String = "Premium Returns"
    static let helpTitle: String = "Help"
    static let headerHeight: Float = 30.0
    static let fontName = FontType.Primary.fontName
    static let fontSize: CGFloat = FontType.Primary.fontSize
    static let helpViewDuration: Double = 0.75
    static let daysToExpiration: Int = 45
    static let tabBarHeight: CGFloat = 50.0
    
    var currentBroker: Broker?
    var currentStrategy: Strategy?
    var trade: Trade!
    var helpViewController: HelpViewController?
    var tradeFormController: TradeFormController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = TradeTableViewController.controllerTitle
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.contentInset = UIEdgeInsets(top: 64.0, left: 0, bottom: 0, right: 0)

        addHelpView()
        
        currentBroker = BrokerController.sharedInstance.resetBroker()
        currentStrategy = StrategyController.sharedInstance.resetStrategy()
        trade = Trade()
        resetTrade()
        
        tradeFormController = TradeFormController(form: form, controller: self)
        tradeFormController?.formSetup()
        resetForm()
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tradeFormController?.refreshForm()
        TradeFormFieldController.sharedInstance.updateInputFields(form: form, premium: trade.premium, maxLoss: trade.maxLoss, pop: trade.pop, contracts: trade.contracts, days: trade.daysToExpiration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!Defaults[.userHasOnboarded]) {
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.showHelpView()
            }
            Defaults[.userHasOnboarded] = true
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func addHelpView() {
        let helpStoryboard = StoryboardFactory().create(name: "Help")
        if let helpViewController = helpStoryboard.instantiateInitialViewController() as? HelpViewController {
            self.helpViewController = helpViewController
            let height = self.view.frame.height - TradeTableViewController.tabBarHeight
            self.helpViewController?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
            self.helpViewController?.view.alpha = 0
            self.helpViewController?.delegate = self
            self.view.addSubview((self.helpViewController?.view)!)
        }
    }
    
    func resetTrade() {
        trade.reset(pop: currentStrategy!.pop, commission: currentBroker!.commission, legs: currentStrategy!.legs, strategy: currentStrategy!.name, maxProfitPercentage: currentStrategy!.maxProfitPercentage)
    }
    
    func resetForm() {
        TradeFormFieldController.sharedInstance.updateInputFields(form: form, premium: trade.premium, maxLoss: trade.maxLoss, pop: trade.pop, contracts: trade.contracts, days: trade.daysToExpiration)
        TradeFormFieldController.sharedInstance.resetOutputFields(form: form, trade: trade, commission: currentBroker!.commission, legs: currentStrategy!.legs)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        resetTrade()
        resetForm()
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

