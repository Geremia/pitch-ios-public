//
//  UsageTracker.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation

class UsageTracker: NSObject {
    
    // MARK: - Properties
    
    private(set) var openTime: Date = Date()
    var currentSessionLength: TimeInterval {
        let rightNow = Date()
        return rightNow.timeIntervalSince(openTime)
    }
    
    // MARK: - Setup
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    // MARK: - Notifications
    
    func appWillEnterForeground() {
        openTime = Date()
    }
}
