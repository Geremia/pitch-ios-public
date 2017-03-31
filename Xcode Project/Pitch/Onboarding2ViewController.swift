//
//  Onboarding2ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

import Permission

class Onboarding2ViewController: OnboardingViewController {
    
    // MARK: - Properties
    
    let permission: Permission = .microphone
    
    // MARK: - Setup Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(_:)), name: .UIApplicationDidBecomeActive, object: nil)
    }

    // MARK: - Actions
    
    @IBAction func allowAccessPressed(_ sender: Any) {
        requestRecordPermission()
    }
    
    func requestRecordPermission() {
        permission.request { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "onboarding24", sender: nil)
                }
            default:
                break
            }
        }
    }
    
    // MARK: - App State Notification
    
    func applicationDidBecomeActive(_ notification: Notification) {
        if permission.status == .authorized {
            self.performSegue(withIdentifier: "onboarding24", sender: nil)
        }
    }
}
