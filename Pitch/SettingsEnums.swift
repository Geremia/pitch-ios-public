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


