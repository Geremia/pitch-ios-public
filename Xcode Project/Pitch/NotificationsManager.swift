//
//  NotificationsManager.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

enum DayType: Int {
    case saturday
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
}

class NotificationsDayData: Object {
    
    // MARK: - Computed Properties
    
    var dayType: DayType {
        let raw = Int(id) ?? 0
        return DayType(rawValue: raw)!
    }
    
    // MARK: - Stored Properties
    
    dynamic var id: String = "0"
    
    /**
     * The earliest time the user has ever opened the app for 
     * this particular day. Results in 10 AM when initially calling
     * firstNotificationTime(for date: Date)
     */
    dynamic var earliestTime: TimeInterval = 37800
    
    /**
     * The latest time the user has ever opened the app for
     * this particular day. Results in 8 PM when initially calling
     * secondNotificationTime(for date: Date)
     */
    dynamic var latestTime: TimeInterval = 68400
    
    // MARK: - Setup
    
    init(dayType: DayType) {
        id = "\(dayType.rawValue)"
        super.init()
    }
    
    required init() { super.init() }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

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
}
