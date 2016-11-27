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
    
    static let allCases: [Key] = [.a, .asharp, .b, .c, .csharp, .d, .dsharp, .e, .f, .fsharp, .g, .gsharp]
    
    static func fromName(_ name: String) -> Key? {
        switch name {
        case "A":
            return Key.a
        case "A♯", "B♭":
            return Key.asharp
        case "B":
            return Key.b
        case "C":
            return Key.c
        case "C♯", "D♭":
            return Key.csharp
        case "D":
            return Key.d
        case "D♯", "E♭":
            return Key.dsharp
        case "E":
            return Key.e
        case "F":
            return Key.f
        case "F♯", "G♭":
            return Key.fsharp
        case "G":
            return Key.g
        case "G♯", "A♭":
            return Key.gsharp
        default:
            return nil
        }
    }
    
    var concertOffset: Int {
        return self.rawValue - 3
    }
    
    var concertOffsetString: String {
        if concertOffset < 0 {
            return String(concertOffset)
        } else {
            return "+\(concertOffset)"
        }
    }
    
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

enum Instrument: Int {
    case piccolo
    case flute
    case oboe
    case englishHorn
    case bassoon
    case eFlatClarinet
    case bFlatClarinet
    case bassClarinet
    case sopranoSax
    case altoSax
    case tenorSax
    case bariSax
    case frenchHorn
    case trumpet
    case trombone
    case bassTrombone
    case euphonium
    case tuba
    
    static let allCases: [Instrument] = [.piccolo, .flute, .oboe, .englishHorn, .bassoon, .eFlatClarinet, .bFlatClarinet, .bassClarinet, .sopranoSax, .altoSax, .tenorSax, .bariSax, .frenchHorn, .trumpet, .trombone, .bassTrombone, .euphonium, .tuba]
    
    var name: String {
        switch self {
        case .piccolo:
            return "Piccolo"
        case .flute:
            return "Flute"
        case .oboe:
            return "Oboe"
        case .englishHorn:
            return "English Horn"
        case .bassoon:
            return "Bassoon"
        case .eFlatClarinet:
            return "E♭ Clarinet"
        case .bFlatClarinet:
            return "B♭ Clarinet"
        case .bassClarinet:
            return "Bass Clarinet"
        case .sopranoSax:
            return "Soprano Sax"
        case .altoSax:
            return "Alto Sax"
        case .tenorSax:
            return "Tenor Sax"
        case .bariSax:
            return "Baritone Sax"
        case .frenchHorn:
            return "French Horn"
        case .trumpet:
            return "Trumpet"
        case .trombone:
            return "Trombone"
        case .bassTrombone:
            return "Bass Trombone"
        case .euphonium:
            return "Euphonium"
        case .tuba:
            return "Tuba"
        }
    }
    
    var key: Key {
        switch self {
        case .piccolo, .flute, .oboe, .bassoon, .trombone, .bassTrombone, .euphonium, .tuba:
            return .c
        case .bFlatClarinet, .bassClarinet, .sopranoSax, .tenorSax, .trumpet:
            return .asharp
        case .englishHorn, .frenchHorn:
            return .f
        case .eFlatClarinet, .altoSax, .bariSax:
            return .dsharp
        }
    }
}
