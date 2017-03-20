//
//  HelpViewController.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 2/26/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

protocol HelpViewControllerProtocol {
    func closeButtonPressed()
}

final class HelpViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var viewCloseButton: UIButton!
    
    var delegate: HelpViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Help"
        self.closeButton.tintColor = StyleManager.theme()
        self.closeButton.backgroundColor = StyleManager.clearTheme()
        self.viewCloseButton.backgroundColor = StyleManager.clearTheme()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.closeButtonPressed()
    }
}
