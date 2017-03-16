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
    
    func setup() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newSessionRecorded(_:)), name: .newSessionRecorded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(doneRecording), name: .doneRecording, object: nil)
    }
    
    // MARK: - Dark Mode
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        
        view.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.white
        sessionsLabel.textColor = darkModeOn ? UIColor.white : UIColor.black
        
        let backImage = darkModeOn ? #imageLiteral(resourceName: "white_back_arrow") : #imageLiteral(resourceName: "back_arrow")
        let newSessionImage = darkModeOn ? #imageLiteral(resourceName: "white_plus") : #imageLiteral(resourceName: "plus")
        backButton.setImage(backImage, for: .normal)
        newSessionButton.setImage(newSessionImage, for: .normal)
    }
}
