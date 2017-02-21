//
//  MainViewController+Setup.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

extension MainViewController {
    
    // MARK: - Setup 
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(openToneGenerator), name: .openToneGenerator, object: nil)
    }
    
    func checkRecordPermission() {
        let recordPermissionGranted = UserDefaults.standard.recordPermission()
        if recordPermissionGranted {
            setupTuner()
        } else {
            requestRecordPermission()
        }
    }
    
    func requestRecordPermission() {
        AKSettings.session.requestRecordPermission() { (granted: Bool) -> Void in
            if granted {
                DispatchQueue.main.async {
                    UserDefaults.standard.setRecordPermission(granted)
                    self.setupTuner()
                }
            }
        }
    }
    
    func setupTuner() {
        tunerSetup = true
        Tuner.sharedInstance.delegate = self
        Tuner.sharedInstance.start()
    }
    
    func setupUI() {
        self.pitchPipeBottomConstraint.constant = -231
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        setupAnalyticsCircle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.darkModeChanged), name: .darkModeChanged, object: nil)
        darkModeChanged()
    }
    
    func setupAnalyticsCircle() {
        analyticsCircle.colorful = false
        analyticsCircle.circleLayer.lineWidth = 1.0
        analyticsCircle.removeBorder()
        
        if today.hasSufficientData {
            shouldUpdateAnalyticsCircle = false
        }
    }
}
