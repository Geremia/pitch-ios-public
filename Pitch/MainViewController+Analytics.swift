//
//  MainViewController+Analytics.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/28/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    // MARK: - Analytics
    
    func addOutputToAnalytics(output: TunerOutput) {
        if output.isValid {
            today.add(tunerOutput: output)
        }
    }
    
    func updatePitchCenterTimer(output: TunerOutput) {
        if output.isValid {
            userPlayedNote()
        } else {
            userStoppedPlaying()
        }
    }
    
    func userPlayedNote() {
        if pitchStartTime == nil {
            recordPitchStartTime()
        }
        
        if !addedCurrentCenterTime {
            if previousPitchWasInTune && state != .inTune {
                /* User was in tune a moment ago, but is now out of tune.
                 * This means they were not able to hold the pitch steady
                 * for at least 0.5 seconds. */
                resetPitchCenterTimer()
                previousPitchWasInTune = false
            } else if !previousPitchWasInTune && state == .inTune {
                /* User was not in tune a moment ago, but is now in tune.
                 * Start timing to see if they can stay in tune for at least
                 * 0.5 seconds. */
                startPitchCenterTimer()
                previousPitchWasInTune = true
            }
        }
    }
    
    func userStoppedPlaying() {
        resetPitchCenterTimer()
        previousPitchWasInTune = false
        pitchStartTime = nil
    }
    
    func recordPitchStartTime() {
        pitchStartTime = Date()
        addedCurrentCenterTime = false
    }
    
    func startPitchCenterTimer() {
        pitchCenterTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.addPitchCenterTimeToAnalytics()
            if self.shouldUpdateAnalyticsCircle {
                self.updateAnalyticsCircle()
            }
        })
    }
    
    func resetPitchCenterTimer() {
        pitchCenterTimer?.invalidate()
        pitchCenterTimer = nil
    }
    
    func addPitchCenterTimeToAnalytics() {
        if let time = self.pitchStartTime {
            let interval = Date().timeIntervalSince(time)
            today.add(timeToCenter: interval - 0.5)
            print(interval - 0.5)
            resetPitchCenterTimer()
            addedCurrentCenterTime = true
        }
    }
}
