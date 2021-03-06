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
        NotificationCenter.default.addObserver(self, selector: #selector(prepareForRecording), name: .prepareForRecording, object: nil)
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
        Mixer.shared.tuner.delegate = self
        Mixer.shared.tuner.start()
    }
    
    func setupUI() {
        recordViewTopConstraint.constant = -recordView.frame.height
        recordLabelUpdateLink = CADisplayLink(target: self, selector: #selector(updateRecordLabel))
        
        analyticsPopupTopConstraint.constant = -analyticsPopupView.frame.height
        shouldCheckForAnalyticsPopup = !DataManager.today().hasSufficientData && UserDefaults.standard.analyticsOn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.darkModeChanged), name: .darkModeChanged, object: nil)
        darkModeChanged()
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        view.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.white
        recordView.backgroundColor = darkModeOn ? UIColor.darkInTune : UIColor.inTune
        analyticsPopupView.backgroundColor = darkModeOn ? UIColor.darkInTune : UIColor.inTune
        
        state = .outOfTune
        transitionViewTo(.outOfTune, animated: false)
        resetMovingLine()
    }
}
