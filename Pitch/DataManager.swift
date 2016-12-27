//
//  DataManager.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/27/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    
    static func today() -> Day {
        let today = Date()
        let components = Calendar.current.dateComponents([.day, .month, .year], from: today)
        
        let realm = try! Realm()
        let days = realm.objects(Day.self).filter("day == %@ AND month == %@ and year == %@", components.day!, components.month!, components.year!)
        print(days)
        if days.count > 0 {
            return days[0]
        } else {
            let day = Day()
            day.day = components.day!
            day.month = components.month!
            day.year = components.year!
            day.id = "\(day.year)\(day.month)\(day.day)"
            
            setToday(day)
            return day
        }
    }
    
    static func setToday(_ newValue: Day) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(newValue, update: true)
        }
    }
    
}
