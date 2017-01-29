//
//  UserDefaults+PitchUserDefaults.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/12/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    /**
     * Whether microphone recording permission has been granted
     * by the user.
     */
    func recordPermission() -> Bool {
        return bool(forKey: "recordPermission")
    }
    
    func setRecordPermission(_ newValue: Bool) {
        set(newValue, forKey: "recordPermission")
    }
    
    /**
     * Bool indicating whether the user has seen the analytics 
     * animation since they last opened the app.
     */
    func hasSeenAnalyticsAnimation() -> Bool {
        return bool(forKey: "hasSeenAnalyticsAnimation")
    }
    
    func setHasSeenAnalyticsAnimation(_ newValue: Bool) {
        set(newValue, forKey: "hasSeenAnalyticsAnimation")
    }
    
    /**
     * Whether the sharing prompt should be shown when the user opens the
     * Analytics screen.
     */
    func shouldShowAnalyticsSharePrompt() -> Bool {
        _ = DataManager.today()
        let pastTwoDays = DataManager.data(forPastDaysIncludingToday: 4)
        
        if pastTwoDays.count == 4 && !userBeforeAnalyticsSharing() {
            // User has been using the app for four days and they were
            // not a user before I added the Analytics sharing requirement,
            // so show them the sharing prompt.
            return true
        }
        
        // User has already shared OR this is their first day using the app.
        return false
    }
    
    func userDidShareFromAnalytics() {
        setUserBeforeAnalyticsSharing(true)
    }
    
    /**
     * Whether the user had the app before the Analytics sharing feature
     * was added.
     */
    func userBeforeAnalyticsSharing() -> Bool {
        return bool(forKey: "userBeforeAnalyticsSharing")
    }
    
    func setUserBeforeAnalyticsSharing(_ newValue: Bool) {
        set(newValue, forKey: "userBeforeAnalyticsSharing")
    }
    
    /**
     * Whether the tutorial should be shown when the user opens the Analytics
     * screen.
     */
    func shouldBypassAnalyticsTutorial() -> Bool {
        return bool(forKey: "shouldBypassAnalyticsTutorial")
    }
    
    func setShouldBypassAnalyticsTutorial(_ newValue: Bool) {
        set(newValue, forKey: "shouldBypassAnalyticsTutorial")
    }
    
    /**
     * The user's selected microphone sensitivity.
     */
    func micSensitivity() -> MicSensitivity {
        if let rawValue = object(forKey: "micSensitivity") as? Int {
            return MicSensitivity(rawValue: rawValue)!
        }
        
        return MicSensitivity.normal
    }
    
    func setMicSensitivity(_ newValue: MicSensitivity) {
        set(newValue.rawValue, forKey: "micSensitivity")
    }
    
    /**
     * The user's selected display mode (♯ or ♭)
     */
    func displayMode() -> DisplayMode {
        if let rawValue = object(forKey: "displayMode") as? Int {
            return DisplayMode(rawValue: rawValue)!
        }
        
        return DisplayMode.flats
    }
    
    func setDisplayMode(_ newValue: DisplayMode) {
        set(newValue.rawValue, forKey: "displayMode")
    }
    
    /**
     * Bool indicating whether the 'auto key' setting is turned on.
     */
    func autoKeyOn() -> Bool {
        if value(forKey: "autoKeyOn") == nil {
            return true
        }
        
        return bool(forKey: "autoKeyOn")
    }
    
    func setAutoKey(_ on: Bool) {
        set(on, forKey: "autoKeyOn")
    }
    
    /**
     * The user's selected instrument.
     */
    func instrument() -> Instrument {
        if let rawValue = object(forKey: "instrument") as? Int {
            return Instrument(rawValue: rawValue)!
        }
        
        return Instrument.flute
    }
    
    func setInstrument(_ newValue: Instrument) {
        set(newValue.rawValue, forKey: "instrument")
    }
    
    /**
     * The user's selected key.
     */
    func key() -> Key {
        if let rawValue = object(forKey: "key") as? Int {
            return Key(rawValue: rawValue)!
        }
        
        return Key.c
    }
    
    func setKey(_ newValue: Key) {
        set(newValue.rawValue, forKey: "key")
    }
    
    /**
     * The pitch standard. A = 440Hz by default.
     */
    func pitchStandard() -> Double {
        if let pitchStandard = object(forKey: "pitchStandard") {
            return pitchStandard as! Double
        }
        
        return 440.0
    }
    
    func setPitchStandard(_ newValue: Double) {
        set(newValue, forKey: "pitchStandard")
        NotificationCenter.default.post(name: .pitchStandardChanged, object: nil)
    }
    
    /**
     * Bool indicating whether 'dark mode' is on.
     */
    func darkModeOn() -> Bool {
        return bool(forKey: "darkModeOn")
    }
    
    func setDarkModeOn(_ on: Bool) {
        set(on, forKey: "darkModeOn")
    }
    
}
