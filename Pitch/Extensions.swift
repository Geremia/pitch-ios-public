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

extension Dictionary {
    public init(keys: [Key], values: [Value]) {
        precondition(keys.count == values.count)
        
        self.init()
        
        for (index, key) in keys.enumerated() {
            self[key] = values[index]
        }
    }
}

extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = CIColor(color: self)
        return (color.red, color.green, color.blue, color.alpha)
    }
    
    static func blend(colors: [UIColor], withIntensities intensities: [CGFloat]) -> UIColor {
        if colors.count != intensities.count { return .white }
        
        let total = intensities.reduce(0, { accumulator, value in
            return accumulator + max(value, 0)
        })
        let relativeIntensities: [CGFloat] = intensities.map({ value in
            return max(value, 0) / total
        })
        
        var colorIntensityPairs: [UIColor : CGFloat] = [:]
        colors.enumerated().forEach({
            colorIntensityPairs[$0.element] = relativeIntensities[$0.offset]
        })
        
        let initialColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let blendedColor: UIColor = colorIntensityPairs.reduce(initialColor, { accumulator, pair in
            let color = pair.key
            let intensity = pair.value
            
            let r = accumulator.components.red + color.components.red * intensity
            let g = accumulator.components.green + color.components.green * intensity
            let b = accumulator.components.blue + color.components.blue * intensity
            let a = accumulator.components.alpha + color.components.alpha * intensity
            
            return UIColor(red: r, green: g, blue: b, alpha: a)
        })
        
        return blendedColor
    }
}

extension Notification.Name {
    static let pitchPipeReset = Notification.Name(rawValue: "pitchPipeResetNotification")
    static let darkModeChanged = Notification.Name(rawValue: "darkModeChangedNotification")
    static let pitchStandardChanged = Notification.Name(rawValue: "pitchStandardChangedNotification")
    static let resetBufferSizes = Notification.Name(rawValue: "resetBufferSizesNotification")
    static let openAnalytics = Notification.Name(rawValue: ShortcutIdentifier.Analytics.rawValue)
    static let openToneGenerator = Notification.Name(rawValue: ShortcutIdentifier.ToneGenerator.rawValue)
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

func log2(val: Double) -> Double {
    return log(val)/log(2.0)
}

func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
