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
}
