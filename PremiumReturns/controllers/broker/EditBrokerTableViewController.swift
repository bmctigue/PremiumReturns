//
//  EditBrokerTableViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/10/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka
import ChameleonFramework

class EditBrokerTableViewController: FormViewController {
    
    static let headerHeight: Float = 30.0
    static let fontName = FontType.Primary.fontName
    static let fontSize: CGFloat = FontType.Primary.fontSize
    static let missingTitle = "Broker Name"
    static let missingMessage = "Your broker needs a unique name."
    
    var brokerFormController: BrokerFormController?
    var broker: Broker?
    var delegate: EditItemTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.backgroundColor = UIColor.white
        setUpNavigationButtons()

        if broker == nil {
            self.broker = Broker()
        }
        
        brokerFormController = BrokerFormController(form: form, controller: self, broker: broker!)
        brokerFormController?.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20
        
        updateInputFields(name: broker!.name, commission: broker!.commission)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func setUpNavigationButtons() {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(EditBrokerTableViewController.cancelButtonPressed))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(EditBrokerTableViewController.doneButtonPressed))
        let topViewController = self.navigationController!.topViewController
        topViewController!.navigationItem.leftBarButtonItem = cancelBarButton
        topViewController!.navigationItem.rightBarButtonItem = doneBarButton
    }
    
    func updateInputFields(name: String, commission: Double) {
        let nameRow: TextRow? = form.rowBy(tag: BrokerFormFieldNames.Name.rawValue)
        nameRow?.value = name
        nameRow?.updateCell()
        
        let commissionRow: DecimalRow? = form.rowBy(tag: BrokerFormFieldNames.Commission.rawValue)
        commissionRow?.value = commission
        commissionRow?.updateCell()
    }

    @objc func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed() {
        let missingNameTitle = EditBrokerTableViewController.missingTitle
        let missingNameMessage = EditBrokerTableViewController.missingMessage
        let validationErrors = form.validate()
        if validationErrors.count == 0 && BrokerController.sharedInstance.isUnique(brokerId: broker!.brokerId, name: broker!.name) {
            BrokerController.sharedInstance.save(broker: broker!)
            self.delegate?.doneButtonPressed()
            self.dismiss(animated: true, completion: nil)
        } else {
            print("\(validationErrors)")
            Utilities.sharedInstance.displayAlert(controller: self, title: missingNameTitle, message: missingNameMessage)
        }
    }
}
