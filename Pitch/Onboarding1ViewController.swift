//
//  Onboarding1ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class Onboarding1ViewController: OnboardingViewController {
    
    // MARK: - Actions
    
    @IBAction func nextPressed(_ sender: Any) {
        performSegue(withIdentifier: "onboarding12", sender: nil)
    }
}
