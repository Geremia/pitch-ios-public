//
//  SessionsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class SessionsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var sessionsLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Variables
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
