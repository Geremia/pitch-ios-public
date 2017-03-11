//
//  MainViewController+Analytics.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/28/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

extension MainViewController {
    
    // MARK: - Analytics
    
    func addOutputToAnalytics(output: TunerOutput) {
        if output.isValid {
            DataManager.today().add(tunerOutput: output)
        }
    }
    
    func addPitchCenterTimeToAnalytics() {
        if let time = self.pitchStartTime {
            let interval = Date().timeIntervalSince(time)
            DataManager.today().add(timeToCenter: interval - 0.5)
            resetPitchCenterTimer()
        }
    }
    
    // MARK: - Session Analytics
    
    func addOutputToSession(output: TunerOutput) {
        
    }
    
    func addCenterTimeToSession() {
        
    }
}
