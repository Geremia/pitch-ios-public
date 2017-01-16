//
//  ShareViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/16/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func updateForDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
            for label in labels {
                label.textColor = .white
            }
            shareButton.backgroundColor = UIColor.darkInTune
        }
    }

    // MARK: - Actions

    @IBAction func shareButtonPressed(_ sender: Any) {
        
    }
}
