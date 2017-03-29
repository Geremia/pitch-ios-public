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

class NotificationsManager: NSObject {
    
    // MARK: - Properties
    
    static let shared: NotificationsManager = NotificationsManager()
    fileprivate let tracker: UsageTracker = UsageTracker()
    fileprivate let realm = try! Realm()
    
    // MARK: - Setup
    
    fileprivate override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: .UIApplicationWillResignActive, object: nil)
    }
    
    // MARK: - Retrieving Data
    
    func firstNotificationTime(for date: Date) -> TimeInterval {
        let type = dayType(for: date)
        let dayData = day(for: type)
        return dayData.earliestTime - 1800
    }
    
    func secondNotificationTime(for date: Date) -> TimeInterval {
        let type = dayType(for: date)
        let dayData = day(for: type)
        return dayData.latestTime + 3600
    }
    
    // MARK: - UIApplication Events
    
    @objc private func appWillEnterForeground() {
        recordAppOpen()
    }
    
    @objc private func appWillResignActive() {
        recordAppClose()
        scheduleNotifications()
    }
    
    // MARK: - Adding Data
    
    func recordAppOpen() {
        let today = Date()
        let type = dayType(for: today)
        let dayData = day(for: type)
        
        try! realm.write {
            let startOfToday = Calendar.current.startOfDay(for: today)
            let intervalSinceStart = today.timeIntervalSince(startOfToday)
            if dayData.earliestTime > intervalSinceStart {
                dayData.earliestTime = intervalSinceStart
            }
        }
    }
    
    func recordAppClose() {
        /* If the user only had the app open for 15 seconds or less, don't count it.
         The intention is to avoid counting when people accidentally open the app
         in the middle of the night. */
        if tracker.currentSessionLength <= 15 { return }
        
        let today = Date()
        let type = dayType(for: today)
        let dayData = day(for: type)
        
        try! realm.write {
            let startOfToday = Calendar.current.startOfDay(for: today)
            let intervalSinceStart = today.timeIntervalSince(startOfToday)
            if dayData.latestTime < intervalSinceStart {
                dayData.latestTime = intervalSinceStart
            }
        }
    }
    
    // MARK: - Scheduling Notifications
    
    func scheduleNotifications() {
        
    }
    
    // MARK: - Helpers
    
    private func days() -> [NotificationsDayData] {
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
    
    private func populateDays() {
        for i in 0..<6 {
            let type = DayType(rawValue: i)
            let day = NotificationsDayData(dayType: type!)
            realm.add(day)
        }
    }
    
    private func dayType(for date: Date) -> DayType {
        let weekDay = Calendar.current.component(.weekday, from: date)
        return DayType(rawValue: weekDay) ?? .saturday
    }
    
    private func day(for dayType: DayType) -> NotificationsDayData {
        if let day = days().filter({ day in
            return day.dayType == dayType
        }).first {
            return day
        }
        
        return NotificationsDayData(dayType: .saturday)
    }
}
