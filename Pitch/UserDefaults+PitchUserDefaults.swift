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
     * animation today.
     */
    func hasSeenAnalyticsAnimation() -> Bool {
        return bool(forKey: "hasSeenAnalyticsAnimation")
    }
    
    func setHasSeenAnalyticsAnimation(_ newValue: Bool) {
        set(newValue, forKey: "hasSeenAnalyticsAnimation")
    }
    
    /**
     * The last day the analytics screen was viewed with sufficient data.
     * Returns nil if the analytics screen has never been viewed.
     */
    func lastAnalyticsViewDate() -> Date? {
        return object(forKey: "lastAnalyticsViewDate") as? Date
    }
    
    func setLastAnalyticsViewDate(_ newValue: Date) {
        set(newValue, forKey: "lastAnalyticsViewDate")
    }
    
    /**
     * Whether the sharing prompt should be shown when the user opens the
     * Analytics screen.
     */
    func shouldShowAnalyticsSharePrompt() -> Bool {
        if let object = object(forKey: "shouldShowAnalyticsSharePrompt") {
            return object as! Bool
        }
        
        return true
    }
    
    func setShouldShowAnalyticsSharePrompt(_ newValue: Bool) {
        set(newValue, forKey: "shouldShowAnalyticsSharePrompt")
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
     * Bool indicating whether 'dark mode' is on.
     */
    func darkModeOn() -> Bool {
        return bool(forKey: "darkModeOn")
    }
    
    func setDarkModeOn(_ on: Bool) {
        set(on, forKey: "darkModeOn")
    }
    
}
