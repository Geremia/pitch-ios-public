//
//  SwipeTutorialViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/18/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class SwipeTutorialViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var hand: UIImageView!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    
    @IBAction func gotItPressed(_ sender: Any) {
    }

    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
