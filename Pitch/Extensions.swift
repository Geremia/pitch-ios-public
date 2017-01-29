//
//  Extensions.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UILabel {
    func setAttributedText(_ text: NSMutableAttributedString, withSpacing spacing: CGFloat) {
        text.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.string.characters.count))
        self.attributedText = text
    }
    
    func setText(_ text: String, withSpacing spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
}

extension Date {
    func adding(numberOfDays: Int) -> Date {
        let currentDate = Calendar.current.startOfDay(for: self)
        let date = Calendar.current.date(byAdding: .day, value: numberOfDays, to: currentDate)!
        return date
    }
    
    var id: String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        let id = String(format: "%04d%02d%02d", components.year!, components.month!, components.day!)
        return id
    }
}

extension Notification.Name {
    static let pitchPipeReset = Notification.Name(rawValue: "pitchPipeResetNotification")
    static let darkModeChanged = Notification.Name(rawValue: "darkModeChangedNotification")
    static let pitchStandardChanged = Notification.Name(rawValue: "pitchStandardChangedNotification")
}

func log2(val: Double) -> Double {
    return log(val)/log(2.0)
}

func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
