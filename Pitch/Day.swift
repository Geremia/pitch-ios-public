//
//  Day.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift

class Day: Object {
    
    // MARK: - Variables
    
    dynamic var date: Date = Date()
    dynamic var id: String = "0"
    
    /**
     * The threshold in cents for being 'in-tune'
     */
    let tuningThreshold: Double = 0.4
    
    /**
     * How often the user was 'in-tune', expressed as a percentage.
     */
    dynamic var inTunePercentage: Double = 1
    
    /**
     * The number of data points added for inTunePercentage.
     */
    dynamic var inTunePercentageDataCount: Int = 0
    
    /**
     * The average time taken to center the pitch.
     */
    dynamic var timeToCenter: TimeInterval = 1
    
    /**
     * The number of data points added for timeToCenter.
     */
    dynamic var timeToCenterDataCount: Int = 0
    
    /**
     * The user's 'tuning score'. Takes into account timeToCenter
     * and inTunePercentage to form a score from 0 - 100.
     */
    var tuningScore: Int {
        /* Exponential decay for center time weight. We want to
        penalize the user less as their time to center the pitch
        increases. Example: Going from 2 seconds to 3 seconds
        would lower the overall score more than going from 6 seconds 
        to 7 seconds. Accounts for 40% of the overall score. */
        let centerTimeWeight = min(40 * 2 / (timeToCenter + 1.5), 40)
        
        // In-tune percentage accounts for 60% of the overall score.
        let inTunePercentageWeight = 60 * inTunePercentage
        
        // Sum the two weights and round to get a score.
        let combinedWeights = centerTimeWeight + inTunePercentageWeight
        return Int(combinedWeights)
    }
    
    /**
     * An array of OffsetData. Each OffsetData contains a pitch, octave,
     * and its average offset. Array is in descending order of the absolute
     * value of every pitch's average offset.
     */
    var pitchOffsets: List<OffsetData> = List<OffsetData>()
    
    /**
     * Returns offset datas that only have more than 300 data points.
     */
    var filteredPitchOffsets: [OffsetData] {
        var offsets: [OffsetData] = []
        offsets.append(contentsOf: pitchOffsets)
        return offsets.filter { data in
            return data.dataCount >= 300
        }
    }
    
    /**
     * Boolean indicating whether enough data has been collected to be 
     * displayed to the user.
     */
    var hasSufficientData: Bool {
        return inTunePercentageDataCount >= 1200 && timeToCenterDataCount >= 3
    }
    
    /**
     * Double, 0 - 1 scale representing how close this Day is to
     * having sufficient data.
     */
    var dataPercentage: Double {
        let inTune = min(0.4 * Double(inTunePercentageDataCount) / 1200, 0.4)
        let timeToCenter = min(0.6 * Double(timeToCenterDataCount) / 3, 0.6)
        return inTune + timeToCenter
    }
    
    // MARK: - Functions
    
    static func newDay() -> Day {
        let day = Day()
        day.id = day.date.id
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
        
        updatePitchOffsets(tunerOutput: tunerOutput)
    }
    
    func updatePitchOffsets(tunerOutput: TunerOutput) {
        let realm = try! Realm()
        try! realm.write {
            let pitch = tunerOutput.pitch
            let offset = tunerOutput.centsDistace
            
            // If the offset is greater than 50 cents, this data point is not valid.
            if abs(offset) > 50.0 { return }
            
            // Check if the pitch is already present in pitchOffsets.
            if let index = pitchOffsets.index(where: { $0.pitch == pitch }) {
                // Pitch is present. Update its averageOffset.
                pitchOffsets[index].add(offset: offset)
            } else {
                // Pitch is not present. Add it to pitchOffsets.
                let offsetData = OffsetData.new(pitch: pitch, offset: offset)
                pitchOffsets.append(offsetData)
            }
            
            // Sort pitchOffsets in descending order by the absolute value of their averageOffset.
            let sortedOffsets = Array(pitchOffsets.sorted(by: { abs($0.averageOffset) > abs($1.averageOffset) }))
            pitchOffsets.removeAll()
            pitchOffsets.append(contentsOf: sortedOffsets)
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
