//
//  ShortcutIdentifier.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/28/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation

enum ShortcutIdentifier: String {
    case Analytics
    case ToneGenerator
    
    init?(fullIdentifier: String) {
        guard let shortIdentifier = fullIdentifier.components(separatedBy: ".").last else {
            return nil
        }
        self.init(rawValue: shortIdentifier)
    }
}
