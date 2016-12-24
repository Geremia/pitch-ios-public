//
//  AnalyticsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/24/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class AnalyticsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var analyticsLabel: UILabel!
    
    @IBOutlet weak var scoreCircle: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todaySeparator: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        updateDarkMode()
    }
    
    // MARK: - Dark Mode Switching
    
    func updateDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            backButton.setImage(#imageLiteral(resourceName: "white_back_arrow"), for: .normal)
            analyticsLabel.textColor = .white
            todayLabel.textColor = .white
            todaySeparator.backgroundColor = .white
            descriptionLabel.textColor = .white
        }
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
