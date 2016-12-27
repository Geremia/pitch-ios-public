//
//  Day.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Day: Object, NSCoding {
    
    // MARK: - Variables
    
    let tuningThreshold: Double = 0.4 // The threshold in cents for being 'in-tune'
    
    var date: Date = Date()
    var inTunePercentage: Double = 1
    var inTunePercentageDataCount: Int = 0 // The number of data points added for inTunePercentage
    var timeToCenter: TimeInterval = 1
    var timeToCenterDataCount: Int = 0 // The number of data points added for timeToCenter
    
    var hasSufficientData: Bool { // Boolean indicating whether enough data has been collected
        return inTunePercentageDataCount >= 100 && timeToCenterDataCount >= 3
    }
    
//    // MARK: - Initialization
//    
//    required init() {
//        date = Date()
//        inTunePercentage = 1
//        inTunePercentageDataCount = 0
//        timeToCenter = 1
//        timeToCenterDataCount = 0
//    }
//    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.inTunePercentage = aDecoder.decodeDouble(forKey: "inTunePercentage")
        self.inTunePercentageDataCount = aDecoder.decodeInteger(forKey: "inTunePercentageDataCount")
        self.timeToCenter = aDecoder.decodeDouble(forKey: "timeToCenter")
        self.timeToCenterDataCount = aDecoder.decodeInteger(forKey: "timeToCenterDataCount")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(inTunePercentage, forKey: "inTunePercentage")
        aCoder.encode(inTunePercentageDataCount, forKey: "inTunePercentageDataCount")
        aCoder.encode(timeToCenter, forKey: "timeToCenter")
        aCoder.encode(timeToCenterDataCount, forKey: "timeToCenterDataCount")
    }
    
    // MARK: - Functions
    
    func addDataPoint(tunerOutput: TunerOutput) {
        inTunePercentageDataCount += 1
        
        let inTune: Double = tunerOutput.distance < tuningThreshold ? 1 : 0
        let newDataPointWeight = 1 / Double(self.inTunePercentageDataCount)
        let oldAverageWeight = 1 - newDataPointWeight
        
        inTunePercentage = (inTunePercentage * oldAverageWeight) + (inTune * newDataPointWeight)
//        print("In-tune \((inTunePercentage * 100).roundTo(places: 2))% of the time.")
    }
    
    func addDataPoint(timeToCenter time: Double) {
        timeToCenterDataCount += 1
        
        let newDataPointWeight = 1 / Double(self.timeToCenterDataCount)
        let oldAverageWeight = 1 - newDataPointWeight
        
        timeToCenter = (timeToCenter * oldAverageWeight) + (time * newDataPointWeight)
//        print("Time to center average: \(timeToCenter.roundTo(places: 2)).")
    }
}
