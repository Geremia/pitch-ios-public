//
//  Day.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import TuningFork

class Day: NSObject {
    
    // MARK: - Variables
    
    let tuningThreshold: Float = 0.5 // The threshold in cents for being 'in-tune'
    
    var date: Date
    var inTunePercentage: Double
    var inTunePercentageDataPoints: Int // The number of data points added for inTunePercentage
    var timeToCenter: Double
    var timeToCenterDataPoints: Int // The number of data points added for timeToCenter
    
    // MARK: - Initialization
    
    override init() {
        date = Date()
        inTunePercentage = -1
        inTunePercentageDataPoints = 0
        timeToCenter = -1
        timeToCenterDataPoints = 0
    }
    
    // MARK: - Functions
    
    func addDataPoint(tunerOutput: TunerOutput) {
        inTunePercentageDataPoints += 1
        
        let inTune: Double = tunerOutput.distance < tuningThreshold ? 1 : 0
        let newDataPointWeight = 1 / Double(self.inTunePercentageDataPoints)
        let oldAverageWeight = 1 - newDataPointWeight
        
        inTunePercentage = (inTunePercentage * oldAverageWeight) + (inTune * newDataPointWeight)
        
        print("In-tune \((inTunePercentage * 100).roundTo(places: 2))% of the time.")
    }
    
    func addDataPoint(timeToCenter: Double) {
        
    }
}
