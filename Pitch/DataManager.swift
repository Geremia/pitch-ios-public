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
        let days = data(forPastDays: 1)
        print(days)
        if days.count > 0 {
            return days[0]
        } else {
            let day = Day.newDay()
            add(day: day)
            return day
        }
    }
    
    fileprivate static func add(day: Day) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(day, update: true)
        }
    }
    
    static func data(forPastDays days: Int) -> Results<Day> {
        let numberOfDays = max(days, 1)
        let startDate = Date.byAdding(numberOfDays: -numberOfDays)
        
        let realm = try! Realm()
        let days = realm.objects(Day.self).filter("date >= %@", startDate)
        return days
    }
}

extension Date {
    static func byAdding(numberOfDays: Int) -> Date {
        let today = Calendar.current.startOfDay(for: Date())
        let date = Calendar.current.date(byAdding: .day, value: (numberOfDays - 1), to: today)!
        return date
    }
    
    static func id(for date: Date) -> String {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        let id = String(format: "%04d%02d%02d", components.year!, components.month!, components.day!)
        return id
    }
}
