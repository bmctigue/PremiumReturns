//
//  LiveTradeViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 4/3/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import Eureka

class LiveTradeViewController: FormViewController {
    
    static let headerHeight: Float = 30.0
    static let fontName = FontType.Primary.fontName
    static let fontSize: CGFloat = FontType.Primary.fontSize
    static let tabBarHeight: CGFloat = 50.0
    
    var trade: Trade!
    var tradeFormController: LiveTradeFormController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = trade.ticker
        self.tableView?.backgroundColor = UIColor.white
        self.tableView?.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0)
        
        tradeFormController = LiveTradeFormController(form: form, trade: self.trade)
        tradeFormController?.formSetup()
        animateScroll = true
        rowKeyboardSpacing = 20
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
}
