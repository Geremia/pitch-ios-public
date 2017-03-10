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
        
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(SessionsViewController.darkModeChanged), name: .darkModeChanged, object: nil)
    }
    
    // MARK: - Dark Mode
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        
        view.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.white
        sessionsLabel.textColor = darkModeOn ? UIColor.white : UIColor.black
        
        let backImage = darkModeOn ? #imageLiteral(resourceName: "white_down_arrow") : #imageLiteral(resourceName: "down_arrow")
        let newSessionImage = darkModeOn ? #imageLiteral(resourceName: "white_plus") : #imageLiteral(resourceName: "plus")
        backButton.setImage(backImage, for: .normal)
        newSessionButton.setImage(newSessionImage, for: .normal)
    }
}
