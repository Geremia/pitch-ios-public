//
//  Onboarding2ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class Onboarding2ViewController: OnboardingViewController {

    // MARK: - Actions
    
    @IBAction func allowAccessPressed(_ sender: Any) {
        requestRecordPermission()
    }
    
    func requestRecordPermission() {
        AKSettings.session.requestRecordPermission() { (granted: Bool) -> Void in
            if granted {
                self.performSegue(withIdentifier: "onboarding23", sender: nil)
            }
        }
    }
}
