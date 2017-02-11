//
//  SettingsEnums.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/7/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

enum MicSensitivity: Int {
    case low
    case normal
    case high
    
    var name: String {
        switch self {
        case .low:
            return "Low"
        case .normal:
            return "Normal"
        case .high:
            return "High"
        }
    }
    
    var amplitudeThreshold: Double {
        switch self {
        case .low:
            return 0.065
        case .normal:
            return 0.045
        case .high:
            return 0.015
        }
    }
}

enum DisplayMode: Int {
    case sharps
    case flats
    
    var name: String {
        switch self {
        case .sharps:
            return "♯"
        case .flats:
            return "♭"
        }
    }
}

enum Difficulty: Int {
    case beginner
    case easy
    case intermediate
    case advanced
    case pro
    
    var name: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .easy:
            return "Easy"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        case .pro:
            return "Pro"
        }
    }
    
    var description: String {
        switch self {
        case .beginner:
            return "±10 cents"
        case .easy:
            return "±7 cents"
        case .intermediate:
            return "±5 cents"
        case .advanced:
            return "±2 cents"
        case .pro:
            return "±1 cent"
        }
    }
    
    var tuningThreshold: Double {
        switch self {
        case .beginner:
            return 10.0
        case .easy:
            return 7.0
        case .intermediate:
            return 5.0
        case .advanced:
            return 2.0
        case .pro:
            return 1.0
        }
    }
}

enum Damping: Int {
    case slow
    case normal
    case fast
    
    var name: String {
        switch self {
        case .slow:
            return "Slow"
        case .normal:
            return "Normal"
        case .fast:
            return "Fast"
        }
    }
    
    var description: String {
        switch self {
        case .slow:
            return "Best for plucked strings and wide vibrato"
        case .normal:
            return "Appropriate for most situations"
        case .fast:
            return "Best for short notes"
        }
    }
    
    var smoothingBufferSize: Int {
        switch self {
        case .slow:
            return 90
        case .normal:
            return 45
        case .fast:
            return 20
        }
    }
    
    var frequencyBufferSize: Int {
        switch self {
        case .slow:
            return 60
        case .normal:
            return 20
        case .fast:
            return 8
        }
    }
}
