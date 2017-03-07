//
//  Session.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift
import AudioKit

typealias SessionAnalytics = Day

class Session: Object {
    
    // MARK: - Computed Properties
    
    var directoryPath: URL {
        return URL(fileURLWithPath: path)
    }
    
    var dateString: String {
        return date.prettyString
    }
    
    var durationString: String {
        let interval: TimeInterval = duration 
        return interval.prettyString
    }
    
    // MARK: - Stored Properties
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var date: Date = Date()
    dynamic var duration: Double = 0
    dynamic var path: String = ""
    dynamic var analytics: SessionAnalytics? = SessionAnalytics.makeNew()
    
    // MARK: - Setup
    
    static func with(name: String, file: AKAudioFile) -> Session {
        let session = Session()
        session.id = session.date.id
        session.name = name
        session.path = file.directoryPath.absoluteString
        session.duration = file.duration
        
        return session
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Deletion
    
    func prepareForDeletion() {
        if FileManager.default.isDeletableFile(atPath: path) {
            try? FileManager.default.removeItem(atPath: path)
        }
    }
}
