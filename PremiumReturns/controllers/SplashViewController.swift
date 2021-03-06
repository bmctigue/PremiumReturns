//
//  SplashViewController.swift
//  BiasBike
//
//  Created by Bruce McTigue on 9/22/16.
//  Copyright © 2016 tiguer. All rights reserved.
//

import UIKit

final class SplashViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.frame = self.view.bounds
        
        containerView.alpha = 1.0
        let trans: CGAffineTransform = containerView.transform.scaledBy(x: 0.01, y: 0.01)
        containerView.transform = trans
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.0, animations: {
            let trans: CGAffineTransform = self.containerView.transform.scaledBy(x: 100.0, y: 100.0)
            self.containerView.transform = trans
        }, completion: {
            (value: Bool) in
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.loadMainView()
            }
        })
    }
    
    func loadMainView() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyboard = StoryboardFactory().create(name: "Main")
        let controller: UITabBarController = storyboard.instantiateInitialViewController() as! UITabBarController
        appDelegate.window?.rootViewController = controller
        
        UIView.transition(with: appDelegate.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {}, completion: {
            (value: Bool) in
            appDelegate.window?.rootViewController = controller
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
