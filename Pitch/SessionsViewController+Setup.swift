//
//  SessionsViewController+Setup.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

extension SessionsViewController {
    
    // MARK: - Setup
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(SessionsViewController.darkModeChanged), name: .darkModeChanged, object: nil)
        darkModeChanged()
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
        }
    }
}
