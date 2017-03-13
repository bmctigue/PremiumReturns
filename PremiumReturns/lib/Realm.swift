//
//  Realm.swift
//  PremiumReturns
//
//  Created by Bruce McTigue on 3/3/17.
//  Copyright © 2017 tiguer. All rights reserved.
//

import UIKit
import RealmSwift

private var realm: Realm!

func configureDefaultRealm() {
    Realm.Configuration.defaultConfiguration = Realm.Configuration()
    do {
        realm = try Realm()
    } catch let error as NSError {
        NSLog("Error opening Realm: \(error.localizedDescription)")
    }
}
