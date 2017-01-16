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
        let days = data(forPastDaysIncludingToday: 1)
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
    
    static func data(forPastDaysIncludingToday days: Int) -> Results<Day> {
        let numberOfDays = max(days, 1)
        let today = NSCalendar.current.startOfDay(for: Date())
        let startDate = today.adding(numberOfDays: -(numberOfDays - 1))
        
        let realm = try! Realm()
        let days = realm.objects(Day.self).filter("date >= %@", startDate)
        return days
    }
}
