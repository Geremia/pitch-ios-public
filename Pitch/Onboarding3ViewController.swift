//
//  Onboarding3ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import UserNotifications

class Onboarding3ViewController: OnboardingViewController {

    // MARK: - Actions
    
    @IBAction func allowAccessPressed(_ sender: Any) {
        requestNotificationsPermission()
    }
    
    func requestNotificationsPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { granted, error in
            if granted {
                self.performSegue(withIdentifier: "onboarding34", sender: nil)
            }
        })
    }
    
    @IBAction func noThanksPressed(_ sender: Any) {
        performSegue(withIdentifier: "onboarding34", sender: nil)
    }
}
