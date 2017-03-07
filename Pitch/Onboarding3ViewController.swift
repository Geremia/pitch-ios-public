//
//  Onboarding3ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import UserNotifications
import Permission

class Onboarding3ViewController: OnboardingViewController {
    
    // MARK: - Properties
    
    let permission: Permission = .notifications

    // MARK: - Actions
    
    @IBAction func allowAccessPressed(_ sender: Any) {
        requestNotificationsPermission()
    }
    
    func requestNotificationsPermission() {
        permission.request { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "onboarding34", sender: nil)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func noThanksPressed(_ sender: Any) {
        performSegue(withIdentifier: "onboarding34", sender: nil)
    }
}
