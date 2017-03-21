//
//  NotificationsManager.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct NotificationsManager {
    
    fileprivate static let realm = try! Realm()
    
    // MARK: - Retrieving Data
    
    static func firstNotificationTime(for date: Date) -> TimeInterval {
        let type = dayType(for: date)
        if let day = days().filter({ day in
            return day.dayType == type
        }).first {
            return day.earliestTime - 1800
        }
        
        return 0
    }
    
    static func secondNotificationTime(for date: Date) -> TimeInterval {
        let type = dayType(for: date)
        if let day = days().filter({ day in
            return day.dayType == type
        }).first {
            return day.latestTime + 3600
        }
        
        return 0
    }
    
    // MARK: - Adding Data
    
    static func userReachedSufficientData() {
        
    }
    
    // MARK: - Helpers
    
    private static func dayType(for date: Date) -> DayType {
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date)
        return DayType(rawValue: weekDay)!
    }

    private static func days() -> [NotificationsDayData] {
        if realm.objects(NotificationsDayData.self).count == 0 {
            populateDays()
        }
        
        let days = realm.objects(NotificationsDayData.self).sorted(by: { day0, day1 in
            let id0: Int = Int(day0.id)!
            let id1: Int = Int(day1.id)!
            return id0 < id1
        })
        
        return days
    }
    
    private static func populateDays() {
        for i in 0..<6 {
            let type = DayType(rawValue: i)
            let day = NotificationsDayData(dayType: type!)
            realm.add(day)
        }
    }
    
    private static func dayType(for date: Date) -> DayType {
        let weekDay = Calendar.current.component(.weekday, from: date)
        return DayType(rawValue: weekDay) ?? .saturday
    }
    
    private static func day(for dayType: DayType) -> NotificationsDayData {
        if let day = days().filter({ day in
            return day.dayType == dayType
        }).first {
            return day
        }
        
        return NotificationsDayData(dayType: .saturday)
    }
}
