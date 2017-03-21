//
//  NotificationsDayData.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation
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
