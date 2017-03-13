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
    
    // MARK: - Stored Properties
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var date: Date = Date()
    dynamic var duration: Double = 0
    dynamic var url: String = ""
    dynamic var analytics: SessionAnalytics?
    
    // MARK: - Setup
    
    required init() {
        analytics = SessionAnalytics()
        super.init()
    }
    
    required init(withRecordedFileUrl url: URL, andAnalytics analyticsObject: SessionAnalytics) {
        id = date.longId
        analytics = analyticsObject
        super.init()
        
        //        if let file = try? AKAudioFile(forReading: url) {
        //            file.exportAsynchronously(name: "\(file.fileName).m4a", baseDir: .documents, exportFormat: .m4a, callback: { processedFile, error in
        //                if error == nil {
        //                    session.url = (processedFile?.url.absoluteString)!
        //                    session.duration = (processedFile?.duration)!
        //                    print("New recording saved.")
        //                } else {
        //                    print("Error saving new recording: \(error)")
        //                }
        //            })
        //        }
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
    
    private func newFileName() -> String {
        let number = UserDefaults.standard.fileNumber()
        return "recording\(number).caf"
    }
    
    // MARK: - Deletion
    
    func prepareForDeletion() {
        if FileManager.default.isDeletableFile(atPath: url) {
            try? FileManager.default.removeItem(atPath: url)
        }
    }
}
