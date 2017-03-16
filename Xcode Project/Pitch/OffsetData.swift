//
//  OffsetData.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/6/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation

import RealmSwift

class OffsetData: Object {
    
    /**
     * The pitch as a Pitch object. The Pitch type cannot be stored as a
     * Realm object, so it must be computed from pitchString and octave.
     */
    var pitch: Pitch {
        let concertOffset = UserDefaults.standard.key().concertOffset
        if let note = Note.fromName(pitchString) {
            return Pitch(note: note, octave: octave) - concertOffset
        }
        return Pitch(note: Note.c, octave: -1)
    }
    
    /**
     * The name of the pitch.
     */
    dynamic var pitchString: String = ""
    
    /**
     * The octave of the pitch.
     */
    dynamic var octave: Int = 0
    
    /**
     * The pitch's average offset in cents.
     */
    dynamic var averageOffset: Double = 0
    
    /**
     * The number of data points added.
     */
    dynamic var dataCount: Double = 0
    
    /**
     * Initializes a new OffsetData from a given Pitch and offset.
     */
    static func new(pitch: Pitch, offset: Double) -> OffsetData {
        let offsetData = OffsetData()
        offsetData.pitchString = pitch.description
        offsetData.octave = pitch.octave
        offsetData.averageOffset = offset
        return offsetData
    }
    
    /**
     * Adds a new data point and recalculates average offset. Must be called
     * within a Realm.write block!
     */
    func add(offset: Double) {
        dataCount += 1
        
        let newDataPointWeight = 1 / Double(dataCount)
        let oldWeight = 1 - newDataPointWeight
        
        averageOffset = (averageOffset * oldWeight) + (offset * newDataPointWeight)
    }
}
