//
//  Key.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/28/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

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
        for key in allCases {
            if name == key.sharpName || name == key.flatName {
                return key
            }
        }
        
        return nil
    }
    
    var concertOffset: Int {
        return self.rawValue - 3
    }
    
    var concertOffsetString: String {
        return concertOffset < 0 ? "\(concertOffset)" : "+\(concertOffset)"
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