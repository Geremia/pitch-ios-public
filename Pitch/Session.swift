//
//  Session.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift

typealias SessionAnalytics = Day

class Session: Object {
    
    // MARK: - Variables
    
    dynamic var name: String = ""
    dynamic var date: Date = Date()
    dynamic var length: Double = 0
    dynamic var path: String = ""
    dynamic var analytics: SessionAnalytics? = SessionAnalytics.makeNew()
    
    // MARK: - Setup
    
    static func newSession(withName name: String, path: URL) -> Session {
        let session = Session()
        session.name = name
        session.path = path.absoluteString
        // CONFIGURE LENGTH BASED ON PATH
        
        return session
    }
}
