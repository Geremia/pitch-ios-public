//
//  Mixer.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/20/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class Mixer: NSObject {
    
    // MARK: - Properties
    
    static let sharedInstance: Mixer = Mixer()
    private var mixer: AKMixer!
    var isSetup: Bool = false
    
    // MARK: - Setup
    
    private override init() {}
    
    func setUp() {
        self.mixer = AKMixer(Tuner.sharedInstance.silence, SoundGenerator.sharedInstance.bank, Player.sharedInstance.player)
        AudioKit.output = mixer
        
        if !AudioKit.audioInUseByOtherApps() {
            AudioKit.start()
            isSetup = true
        }
        
        try! AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        try! AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChanged(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func audioRouteChanged(_ notification: Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            return
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            return
        default:
            if !isSetup {
                self.setUp()
            }
        }
    }
}
