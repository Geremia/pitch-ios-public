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
            NotificationCenter.default.post(name: .reloadAnalyticsData, object: nil)
            addOutputToSession(output: output)
        }
    }
    
    func addPitchCenterTimeToAnalytics() {
        if let time = pitchStartTime {
            let interval = Date().timeIntervalSince(time)
            DataManager.today().add(timeToCenter: interval - 0.5)
            addCenterTimeToSession()
            resetPitchCenterTimer()
        }
    }
    
    // MARK: - Session Analytics
    
    func addOutputToSession(output: TunerOutput) {
        if output.isValid, let analytics = sessionAnalytics, recordingState == .recording {
            if !analytics.isInvalidated {
                analytics.add(tunerOutput: output)
            }
        }
    }
    
    func addCenterTimeToSession() {
        if let time = pitchStartTime, let analytics = sessionAnalytics, recordingState == .recording {
            if !analytics.isInvalidated {
                let interval = Date().timeIntervalSince(time)
                analytics.add(timeToCenter: interval - 0.5)
            }
        }
    }
}
