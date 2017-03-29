//
//  Session.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/2/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import AudioKit

class SessionAnalytics: Day {
    
    // MARK: - Stored Properties
    
    dynamic var hasSeenAnimation: Bool = false
    
    // MARK: - Setup
    
    required init() {
        super.init()
        self.id = date.longId
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

class Session: Object {
    
    // MARK: - Computed Properties
    
    var dateString: String {
        return date.prettyString
    }
    
    var durationString: String {
        let interval: TimeInterval = duration 
        return interval.prettyString
    }
    
    var audioFileUrl: URL {
        return documentDirectory().appendingPathComponent(fileName)
    }
    
    // MARK: - Stored Properties
    
    dynamic var id: String = ""
    dynamic var name: String = "New session"
    dynamic var date: Date = Date()
    dynamic var duration: Double = 0
    dynamic var fileName: String = ""
    dynamic var analytics: SessionAnalytics?
    
    // MARK: - Setup
    
    required init() {
        id = date.longId
        analytics = SessionAnalytics()
        super.init()
    }
    
    required init(withRecordedFileUrl url: URL, analytics analyticsObject: SessionAnalytics) {
        id = date.longId
        analytics = analyticsObject
        fileName = url.lastPathComponent
        
        let asset = AVURLAsset(url: url)
        duration = Double(CMTimeGetSeconds(asset.duration))
        
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    fileprivate func newFileName() -> String {
        let number = UserDefaults.standard.fileNumber()
        return "recording\(number).caf"
    }
    
    fileprivate func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Deletion
    
    func prepareForDeletion() {
        if FileManager.default.isDeletableFile(atPath: audioFileUrl.path) {
            try? FileManager.default.removeItem(at: audioFileUrl)
        }
    }
}
