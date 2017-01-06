//
//  Day.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Day: Object {
    
    // MARK: - Variables
    
    dynamic var date: Date = Date()
    dynamic var id: String = "0"
    
    /**
     The threshold in cents for being 'in-tune'
     */
    let tuningThreshold: Double = 0.4
    
    /**
     How often the user was 'in-tune', expressed as a percentage.
     */
    dynamic var inTunePercentage: Double = 1
    
    /**
     The number of data points added for inTunePercentage.
     */
    dynamic var inTunePercentageDataCount: Int = 0
    
    /**
     The average time taken to center the pitch.
     */
    dynamic var timeToCenter: TimeInterval = 1
    
    /**
     The number of data points added for timeToCenter.
     */
    dynamic var timeToCenterDataCount: Int = 0
    
    /**
     Boolean indicating whether enough data has been collected to be displayed to the user.
     */
    var hasSufficientData: Bool {
        return inTunePercentageDataCount >= 100 && timeToCenterDataCount >= 3
    }
    
    // MARK: - Functions
    
    static func newDay() -> Day {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        let day = Day()
        day.id = "\(components.year!)\(components.month!)\(components.day!)"
        return day
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Data Point Adding 
    
    func add(tunerOutput: TunerOutput) {
        let realm = try! Realm()
        try! realm.write {
            inTunePercentageDataCount += 1
            
            let inTune: Double = tunerOutput.distance < tuningThreshold ? 1 : 0
            let newDataPointWeight = 1 / Double(self.inTunePercentageDataCount)
            let oldAverageWeight = 1 - newDataPointWeight
            
            inTunePercentage = (inTunePercentage * oldAverageWeight) + (inTune * newDataPointWeight)
        }
    }
    
    func add(timeToCenter time: Double) {
        let realm = try! Realm()
        try! realm.write {
            timeToCenterDataCount += 1
            
            let newDataPointWeight = 1 / Double(self.timeToCenterDataCount)
            let oldAverageWeight = 1 - newDataPointWeight
            
            timeToCenter = (timeToCenter * oldAverageWeight) + (time * newDataPointWeight)
        }
    }
}
