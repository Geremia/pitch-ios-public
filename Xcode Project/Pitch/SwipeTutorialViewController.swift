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
    @IBOutlet weak var handTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating()
    }
    
    // MARK: - Animation
    
    func startAnimating() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func gotItPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
