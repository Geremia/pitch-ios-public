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
    
    func addPitchCenterTimeToAnalytics() {
        if let time = self.pitchStartTime {
            let interval = Date().timeIntervalSince(time)
            today.add(timeToCenter: interval - 0.5)
            print(interval - 0.5)
            resetPitchCenterTimer()
        }
    }
}
