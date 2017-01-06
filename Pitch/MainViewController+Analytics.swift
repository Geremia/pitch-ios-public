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
            if pitchStartTime == nil {
                startTimingPitch()
            }
            
            if state == .inTune {
                pitchCenterTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
                    if !self.addedCurrentCenterTime {
                        self.addPitchCenterTimeToAnalytics()
                    }
                })
            }
        } else {
            stopTimingPitch()
            pitchStartTime = nil
        }
    }
    
    func startTimingPitch() {
        pitchStartTime = Date()
        addedCurrentCenterTime = false
    }
    
    func stopTimingPitch() {
        pitchCenterTimer?.invalidate()
        pitchCenterTimer = nil
        addedCurrentCenterTime = true
    }
    
    func addPitchCenterTimeToAnalytics() {
        if let time = self.pitchStartTime {
            let interval = Date().timeIntervalSince(time)
            today.add(timeToCenter: interval)
            stopTimingPitch()
        }
    }
    
}
