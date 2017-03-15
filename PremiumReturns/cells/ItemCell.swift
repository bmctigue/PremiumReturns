//
//  ItemCell.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/14/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    func updateCell(title: String, detailText: String) {
        self.textLabel?.text = title
        self.detailTextLabel?.text = detailText
    }
}
