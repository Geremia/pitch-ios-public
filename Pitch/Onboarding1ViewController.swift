//
//  Onboarding1ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class Onboarding1ViewController: OnboardingViewController {
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGR)
    }
    
    // MARK: - Tap Gesture Recognizer
    
    func viewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "onboarding12", sender: nil)
    }
}
