//
//  UserDefaults+PitchUserDefaults.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

extension UserDefaults {
    func today() -> Day {
        if let data = data(forKey: "today") {
            let day: Day = NSKeyedUnarchiver.unarchiveObject(with: data) as! Day
            if NSCalendar.current.isDateInToday(day.date) {
                return day
            }
        }
        
        let today = Day()
        setToday(today)
        return today
    }
    
    func setToday(_ today: Day) {
        let data = NSKeyedArchiver.archivedData(withRootObject: today)
        set(data, forKey: "today")
    }
    
    func micSensitivity() -> MicSensitivity {
        if let rawValue = object(forKey: "micSensitivity") as? Int {
            return MicSensitivity(rawValue: rawValue)!
        }
        
        return MicSensitivity.normal
    }
    
    func setMicSensitivity(newValue: MicSensitivity) {
        set(newValue.rawValue, forKey: "micSensitivity")
    }
    
    func displayMode() -> DisplayMode {
        if let rawValue = object(forKey: "displayMode") as? Int {
            return DisplayMode(rawValue: rawValue)!
        }
        
        return DisplayMode.sharps
    }
    
    func setDisplayMode(newValue: DisplayMode) {
        set(newValue.rawValue, forKey: "displayMode")
    }
    
    func key() -> Key {
        if let rawValue = object(forKey: "key") as? Int {
            return Key(rawValue: rawValue)!
        }
        
        return Key.c
    }
    
    func setKey(newValue: Key) {
        set(newValue.rawValue, forKey: "key")
    }
    
    func darkModeOn() -> Bool {
        return bool(forKey: "darkModeOn")
    }
    
    func setDarkModeOn(_ on: Bool) {
        set(on, forKey: "darkModeOn")
    }
}
