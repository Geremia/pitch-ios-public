//
//  Pitch.swift
//  Perfect Pitch
//
//  Created by Daniel Kuntz on 7/1/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

enum Pitch: Double {
    
    case a4 = 220.0
    case aSharp4 = 233.08
    case b4 = 246.94
    case c4 = 261.63
    case cSharp4 = 277.18
    case d4 = 293.66
    case dSharp4 = 311.13
    case e4 = 329.63
    case f4 = 349.23
    case fSharp4 = 369.99
    case g4 = 392.00
    case gSharp4 = 415.30
    
    case a5 = 440.0
    case aSharp5 = 466.17
    case b5 = 493.86
    case c5 = 523.25
    case cSharp5 = 554.37
    case d5 = 587.33
    case dSharp5 = 622.25
    case e5 = 659.25
    case f5 = 698.46
    case fSharp5 = 739.99
    case g5 = 783.99
    case gSharp5 = 830.61
    
    case a6 = 880.0
    case aSharp6 = 932.33
    case b6 = 987.77
    case c6 = 1046.50
    case cSharp6 = 1108.73
    case d6 = 1174.66
    case dSharp6 = 1244.51
    case e6 = 1318.51
    case f6 = 1396.91
    case fSharp6 = 1479.98
    case g6 = 1567.98
    case gSharp6 = 1661.22
    
    static let octaveOnePitches: [Pitch] = [.a4, .aSharp4, .b4, .c4, .cSharp4, .d4, .dSharp4, .e4, .f4, .fSharp4, .g4, .gSharp4]
    static let octaveTwoPitches: [Pitch] = [.a5, .aSharp5, .b5, .c5, .cSharp5, .d5, .dSharp5, .e5, .f5, .fSharp5, .g5, .gSharp5]
    static let octaveThreePitches: [Pitch] = [.a6, .aSharp6, .b6, .c6, .cSharp6, .d6, .dSharp6, .e6, .f6, .fSharp6, .g6, .gSharp6]
    
    init(shortName: String, octave: Int) {
        let pitchSetToIterate: [Pitch]
        if octave == 1 {
            pitchSetToIterate = Pitch.octaveOnePitches
        } else if octave == 2 {
            pitchSetToIterate = Pitch.octaveTwoPitches
        } else {
            pitchSetToIterate = Pitch.octaveThreePitches
        }
        
        var rawValue: Double = Pitch.c4.rawValue
        for pitch in pitchSetToIterate {
            if pitch.shortName() == shortName {
                rawValue = pitch.rawValue
            }
        }
        
        self.init(rawValue: rawValue)!
    }
    
    func frequency() -> Double {
        return self.rawValue
    }
    
    func octave() -> Int {
        if self.frequency() < 500.0 {
            return 1
        } else if self.frequency() < 1000.0 {
            return 2
        } else {
            return 3
        }
    }
    
    func shortName() -> String {
        switch self {
        case .c4, .c5, .c6:
            return "C"
        case .cSharp4, .cSharp5, .cSharp6:
            return "C#"
        case .d4, .d5, .d6:
            return "D"
        case .dSharp4, .dSharp5, .dSharp6:
            return "D#"
        case .e4, .e5, .e6:
            return "E"
        case .f4, .f5, .f6:
            return "F"
        case .fSharp4, .fSharp5, .fSharp6:
            return "F#"
        case .g4, .g5, .g6:
            return "G"
        case .gSharp4, .gSharp5, .gSharp6:
            return "G#"
        case .a4, .a5, .a6:
            return "A"
        case .aSharp4, .aSharp5, .aSharp6:
            return "A#"
        case .b4, .b5, .b6:
            return "B"
        }
    }
    
    func longName() -> String {
        if !self.isAccidental() {
            return shortName()
        } else {
            switch self {
            case .cSharp4, .cSharp5, .cSharp6:
                return "C#/Db"
            case .dSharp4, .dSharp5, .dSharp6:
                return "D#/Eb"
            case .fSharp4, .fSharp5, .fSharp6:
                return "F#/Gb"
            case .gSharp4, .gSharp5, .gSharp6:
                return "G#/Ab"
            case .aSharp4, .aSharp5, .aSharp6:
                return "A#/Bb"
            default:
                return "C"
            }
        }
    }
    
    func isAccidental() -> Bool {
        return shortName().characters.count != 1
    }
    
}
