//
//  UIColor+PitchColors.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/16/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @nonobjc static let almostInTune: UIColor = UIColor(red: 204/255.0, green: 255/255.0, blue: 229/255.0, alpha: 1.0)
    @nonobjc static let inTune: UIColor = UIColor(red: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1.0)
    @nonobjc static let darkAlmostInTune: UIColor = UIColor(red: 0/255.0, green: 51/255.0, blue: 25/255.0, alpha: 1.0)
    @nonobjc static let darkInTune: UIColor = UIColor(red: 0/255.0, green: 179/255.0, blue: 86/255.0, alpha: 1.0)
    
    @nonobjc static let grayText: UIColor = UIColor(red: 89/255.0, green: 89/255.0, blue: 89/255.0, alpha: 1.0)
    @nonobjc static let darkGrayView: UIColor = UIColor(white: 0.15, alpha: 1.0)
    @nonobjc static let separatorColor: UIColor = UIColor(white: 0.95, alpha: 1.0)
    @nonobjc static let darkSeparatorColor: UIColor = UIColor(white: 0.18, alpha: 1.0)
    
    @nonobjc static let pitchPipeBackground: UIColor = UIColor(white: 0.99, alpha: 1.0)
    @nonobjc static let darkPitchPipeBackground: UIColor = UIColor.darkSeparatorColor
    
    @nonobjc static let lighterRed: UIColor = UIColor(red: 255/255.0, green: 50/255.0, blue: 50/255.0, alpha: 1.0)
    @nonobjc static let textLighterRed: UIColor = UIColor(red: 255/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0)
    @nonobjc static let lighterPurple: UIColor = UIColor(red: 196/255.0, green: 76/255.0, blue: 255/255.0, alpha: 1.0)
}
