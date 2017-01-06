//
//  Day.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift

class OffsetData: Object {
    
    /**
     * The pitch as a Pitch object. The Pitch type cannot be stored as a
     * Realm object, so it must be computed from pitchString and octave.
     */
    var pitch: Pitch {
        let note = Note.fromName(pitchString)
        return Pitch(note: note!, octave: octave)
    }
    
    /**
     * The name of the pitch.
     */
    fileprivate dynamic var pitchString: String = ""
    
    /**
     * The octave of the pitch.
     */
    fileprivate dynamic var octave: Int = 0
    
    /**
     * The pitch's average offset in cents.
     */
    dynamic var averageOffset: Double = 0
    
    /**
     * The number of data points added.
     */
    dynamic var dataCount: Double = 0
    
    static func new(pitch: Pitch, offset: Double) -> OffsetData {
        let offsetData = OffsetData()
        offsetData.pitchString = pitch.description
        offsetData.octave = pitch.octave
        offsetData.averageOffset = offset
        return offsetData
    }
    
    /**
     * Add a new data point and recalculate average offset.
     */
    func add(offset: Double) {
        dataCount += 1
        
        let newDataPointWeight = 1 / Double(dataCount)
        let oldWeight = 1 - newDataPointWeight
        
        averageOffset = (averageOffset * oldWeight) + (offset * newDataPointWeight)
    }
}

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
     * A dictionary containing each pitch played along with that pitch's average offset in cents.
     */
    var pitchOffsets: List<OffsetData> = List<OffsetData>()
    
    /**
     * Boolean indicating whether enough data has been collected to be displayed to the user.
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
        
        updatePitchOffsets(tunerOutput: tunerOutput)
    }
    
    func updatePitchOffsets(tunerOutput: TunerOutput) {
        let realm = try! Realm()
        try! realm.write {
            let pitch = tunerOutput.pitch
            let offset = tunerOutput.centsDistace
            
            /* Check if the pitch is already present in pitchOffsets. */
            if let index = pitchOffsets.index(where: { $0.pitch == pitch }) {
                /* Pitch is present. Update its averageOffset. */
                pitchOffsets[index].add(offset: offset)
            } else {
                /* Pitch is not present. Add it to pitchOffsets */
                let offsetData = OffsetData.new(pitch: pitch, offset: offset)
                pitchOffsets.append(offsetData)
            }
            
            /* Sort pitchOffsets in descending order by averageOffset. */
            let sortedOffsets = Array(pitchOffsets.sorted(by: { abs($0.averageOffset) > abs($1.averageOffset) }))
            pitchOffsets.removeAll()
            pitchOffsets.append(contentsOf: sortedOffsets)
            
            print(pitchOffsets)
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
