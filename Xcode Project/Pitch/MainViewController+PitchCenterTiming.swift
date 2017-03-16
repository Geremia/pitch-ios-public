//
//  MainViewController+PitchCenterTiming.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/7/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation

extension MainViewController {
    
    // MARK: - Pitch Center Timing
    
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
        
        if previousPitchWasInTune && !state.isWithinTuningThreshold {
            /* User was in tune a moment ago, but is now out of tune.
             * This means they were not able to hold the pitch steady
             * for at least 0.5 seconds. */
            resetPitchCenterTimer()
            previousPitchWasInTune = false
        } else if !previousPitchWasInTune && state.isWithinTuningThreshold {
            /* User was not in tune a moment ago, but is now in tune.
             * Start timing to see if they can stay in tune for at least
             * 0.5 seconds. */
            startPitchCenterTimer()
            previousPitchWasInTune = true
        }
    }
    
    func userStoppedPlaying() {
        resetPitchCenterTimer()
        previousPitchWasInTune = false
        pitchStartTime = nil
    }
    
    func recordPitchStartTime() {
        pitchStartTime = Date()
    }
    
    func startPitchCenterTimer() {
        pitchCenterTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.addPitchCenterTimeToAnalytics()
            self.setViewTo(newState: .inTune)
            if self.shouldUpdateAnalyticsCircle {
//                self.updateAnalyticsCircle()
            }
        })
    }
    
    func resetPitchCenterTimer() {
        pitchCenterTimer?.invalidate()
        pitchCenterTimer = nil
    }
    
}
