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
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let realm = try! Realm()
        let days = realm.objects(Day.self).filter("date >= %@", startOfToday)
        
        print(lastSevenDays())
        
        if days.count > 0 {
            return days[0]
        } else {
            let day = Day.newDay()
            setToday(day)
            return day
        }
    }
    
    fileprivate static func setToday(_ newValue: Day) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(newValue, update: true)
        }
    }
    
    static func lastSevenDays() -> Results<Day> {
        let today = Calendar.current.startOfDay(for: Date())
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        
        let realm = try! Realm()
        let days = realm.objects(Day.self).filter("date >= %@", sevenDaysAgo)
        print(days)
        return days
    }
}
