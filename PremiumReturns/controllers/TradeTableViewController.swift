//
//  TradeTableViewController.swift
//  TastyReturns
//
//  Created by Bruce McTigue on 2/22/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework

enum SectionNames: String {
    case Strategies = "STRATEGIES"
    case Returns = "RETURNS"
    case Data = "DATA"
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
    var calculatedReturn: Double = 0.0
    var returnOnCapital: Double = 0.0
    var helpViewController: HelpViewController?
    var tradeFormController: TradeFormController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Returns"
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        self.resetBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        self.helpBarButton.tintColor = UIColor(hexString: Constants.barButtonTintColor)
        
        tradeFormController = TradeFormController(form: form, controller: self)
        tradeFormController?.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20

        addHelpView()
        resetBroker()
        resetTrade()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tradeFormController?.refreshForm()
        updateInputFields(premium: trade.premium, loss: trade.loss, contracts: trade.contracts, days: trade.daysToExpiration)
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
    
    func updateInputFields(premium: Double, loss: Double, contracts: Int, days: Int) {
        let premiumRow: DecimalRow? = form.rowBy(tag: FormFieldNames.Premium.rawValue)
        premiumRow?.value = premium
        premiumRow?.updateCell()
        
        let lossRow: DecimalRow? = form.rowBy(tag: FormFieldNames.MaxLoss.rawValue)
        lossRow?.value = loss
        lossRow?.updateCell()
        
        let contractsRow: IntRow? = form.rowBy(tag: FormFieldNames.Contracts.rawValue)
        contractsRow?.value = contracts
        contractsRow?.updateCell()
        
        let dteRow: IntRow? = form.rowBy(tag: FormFieldNames.DaysToExpiration.rawValue)
        dteRow?.value = days
        dteRow?.updateCell()
    }
    
    func updateOutputFields() {
        
        let commissions = trade.totalCommissions(commissionPerContract: currentBroker!.commission, legs: currentStrategy!.legs)

        calculatedReturn = trade.calculate(maxProfitPercentage: currentStrategy!.maxProfitPercentage, winningProbability: currentStrategy!.winningProbability, contracts: trade.contracts, commissions: commissions)
        let returnOnCapital = trade.returnOnCapital(profit: calculatedReturn, maxLoss: trade.loss)
        let returnPerDay = trade.returnPerDay(totalReturn: returnOnCapital, days: trade.daysToExpiration)
        
        let expectedReturnRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.Trade.rawValue)
        let returnValue =  Utilities.sharedInstance.formatOutput(value: calculatedReturn, showType: true)
        expectedReturnRow?.value = "\(returnValue)"
        expectedReturnRow?.updateCell()
        
        let rocRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.ROC.rawValue)
        let rocValue = Utilities.sharedInstance.formatOutput(value: returnOnCapital, showType: false)
        rocRow?.value = "\(rocValue)"
        rocRow?.updateCell()
        
        let commissionsRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.Commissions.rawValue)
        let commissionsValue = Utilities.sharedInstance.formatOutput(value: commissions, showType: true)
        commissionsRow?.value = "\(commissionsValue)"
        commissionsRow?.updateCell()
        
        let returnPerDayRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.ReturnPerDay.rawValue)
        let returnPerDayRowValue = Utilities.sharedInstance.formatOutput(value: returnPerDay, showType: true)
        returnPerDayRow?.value = "\(returnPerDayRowValue)"
        returnPerDayRow?.updateCell()
    }
    
    func resetOutputFields() {
        let strategies = StrategyController.sharedInstance.all()
        let firstStrategy = strategies.first
        let strategyRow: ActionSheetRow<String>? = form.rowBy(tag: FormFieldNames.Strategy.rawValue)
        strategyRow?.value = firstStrategy?.name
        strategyRow?.updateCell()
        
        let expectedReturnRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.Trade.rawValue)
        expectedReturnRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        expectedReturnRow?.updateCell()
        
        let rocRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.ROC.rawValue)
        rocRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: false)
        rocRow?.updateCell()
        
        let commissionsRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.Commissions.rawValue)
        commissionsRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        commissionsRow?.updateCell()
        
        let returnPerDayRow: LabelRow? = self.form.rowBy(tag: FormFieldNames.ReturnPerDay.rawValue)
        returnPerDayRow?.value = Utilities.sharedInstance.formatOutput(value: 0, showType: true)
        returnPerDayRow?.updateCell()
    }
    
    func resetTrade() {
        resetStrategy()
        trade.premium = 0
        trade.loss = 0
        trade.contracts = 1
        trade.daysToExpiration = TradeTableViewController.daysToExpiration
        updateInputFields(premium: trade.premium, loss: trade.loss, contracts: trade.contracts, days: trade.daysToExpiration)
        resetOutputFields()
    }
    
    func resetStrategy() {
        let allStrategies = StrategyController.sharedInstance.all()
        if allStrategies.count > 0 {
            currentStrategy = allStrategies.first!
        }
    }
    
    func resetBroker() {
        let allBrokers = BrokerController.sharedInstance.all()
        if allBrokers.count > 0 {
            currentBroker = allBrokers.first!
        }
    }

    @IBAction func resetButtonPressed(_ sender: Any) {
        resetTrade()
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        if helpViewController?.view.alpha == 0 {
            showHelpView()
        } else {
            closeButtonPressed()
        }
    }
    
    func showHelpView() {
        self.title = "Help"
        UIView.animate(withDuration: TradeTableViewController.helpViewDuration, animations: {
            self.helpViewController?.view.alpha = 1.0
        })
    }
    
    func closeButtonPressed() {
        self.title = "TastyReturns"
        UIView.animate(withDuration: TradeTableViewController.helpViewDuration, animations: {
            self.helpViewController?.view.alpha = 0
        })
    }
}


