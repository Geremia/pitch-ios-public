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
    
    var amplitudeThreshold: Float {
        switch self {
        case .low:
            return 0.055
        case .normal:
            return 0.045
        case .high:
            return 0.025
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

enum Key: Int {
    case a
    case asharp
    case b
    case c
    case csharp
    case d
    case dsharp
    case e
    case f
    case fsharp
    case g
    case gsharp
    
    var name: String {
        let displayMode = UserDefaults.standard.displayMode()
        switch displayMode {
        case .sharps:
            return sharpName
        case .flats:
            return flatName
        }
    }
    
    var sharpName: String {
        switch self {
        case .a:
            return "A"
        case .asharp:
            return "A♯"
        case .b:
            return "B"
        case .c:
            return "C"
        case .csharp:
            return "C♯"
        case .d:
            return "D"
        case .dsharp:
            return "D♯"
        case .e:
            return "E"
        case .f:
            return "F"
        case .fsharp:
            return "F♯"
        case .g:
            return "G"
        case .gsharp:
            return "G♯"
        }
    }
    
    var flatName: String {
        switch self {
        case .a, .b, .c, .d, .e, .f, .g:
            return sharpName
        case .asharp:
            return "B♭"
        case .csharp:
            return "D♭"
        case .dsharp:
            return "E♭"
        case .fsharp:
            return "G♭"
        case .gsharp:
            return "A♭"
        }
    }
}
