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
    
    fileprivate static let realm = try! Realm()
    
    static func resetToday() {
        let day = today()
        try! realm.write {
            realm.delete(day)
        }
    }
    
    static func today() -> Day {
        let days = data(forPastDaysIncludingToday: 1)
        if days.count > 0 {
            return days[0]
        } else {
            let day = Day.makeNew()
            add(day: day)
            sendUsageStatistics()
            return day
        }
    }
    
    static func data(forPastDaysIncludingToday days: Int) -> Results<Day> {
        let numberOfDays = max(days, 1)
        let today = NSCalendar.current.startOfDay(for: Date())
        let startDate = today.adding(numberOfDays: -(numberOfDays - 1))
        
        let days = realm.objects(Day.self).filter("date >= %@", startDate)
        return days
    }
    
    fileprivate static func add(day: Day) {
        try! realm.write {
            realm.add(day, update: true)
        }
    }
    
    fileprivate static func sendUsageStatistics() {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.sendUsageStatistics()
    }
}
