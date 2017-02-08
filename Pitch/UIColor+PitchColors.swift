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
    
    @nonobjc static let pitchPipeBackground: UIColor = UIColor(white: 0.99, alpha: 1.0)
    @nonobjc static let darkPitchPipeBackground: UIColor = UIColor(white: 0.18, alpha: 1.0)
    
    @nonobjc static let lighterPurple: UIColor = UIColor(red: 196/255.0, green: 76/255.0, blue: 255/255.0, alpha: 1.0)
    
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
