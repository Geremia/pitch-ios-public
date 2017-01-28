//
//  Instrument.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/28/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

enum Instrument: Int {
    case none
    case guitar
    case ukelele
    case violin
    case viola
    case cello
    case stringbass
    case piano
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
    case timpani
    
    static let all: [Instrument] = [.none, .guitar, .ukelele, .violin, .viola, .cello, .stringbass, .piano, .piccolo, .flute, .oboe, .englishHorn, .bassoon, .eFlatClarinet, .bFlatClarinet, .bassClarinet, .sopranoSax, .altoSax, .tenorSax, .bariSax, .frenchHorn, .trumpet, .trombone, .bassTrombone, .euphonium, .tuba, .timpani]
    
    var description: String {
        switch self {
        case .none:
            return "None"
        case .guitar:
            return "Guitar"
        case .ukelele:
            return "Ukelele"
        case .violin:
            return "Violin"
        case .viola:
            return "Viola"
        case .cello:
            return "Cello"
        case .stringbass:
            return "String Bass"
        case .piano:
            return "Piano"
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
        case .timpani:
            return "Timpani"
        }
    }
    
    var key: Key {
        switch self {
        case .none, .guitar, .ukelele, .violin, .viola, .cello, .stringbass, .piano, .piccolo, .flute, .oboe, .bassoon, .trombone, .bassTrombone, .euphonium, .tuba, .timpani:
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
