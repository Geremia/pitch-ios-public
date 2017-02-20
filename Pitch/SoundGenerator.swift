//
//  SoundGenerator.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/30/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import AudioKit

class SoundGenerator : NSObject {
    
    static let sharedInstance: SoundGenerator = SoundGenerator()
    
    private var bank: AKOscillatorBank!
    private var mixer: AKMixer!
    private var octaveConstant: Int = 60
    private var channelsOn: [Int] = [] {
        didSet {
            Constants.pitchPipeIsPlayingSound = channelsOn.count > 0
        }
    }
    
    var tuner: Tuner = Tuner.sharedInstance
    var isSetup: Bool = false
    
    func setUp() {
        self.mixer = AKMixer(tuner.silence)
        
        bank = AKOscillatorBank(waveform: AKTable(.triangle), attackDuration: 0.06, releaseDuration: 0.06)
        mixer.connect(bank)
        
        AudioKit.output = mixer
        try! AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        if !AudioKit.audioInUseByOtherApps() {
            AudioKit.start()
            isSetup = true
        }
        
        setPitchStandard()
        NotificationCenter.default.addObserver(self, selector: #selector(setPitchStandard), name: .pitchStandardChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChanged(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func audioRouteChanged(_ notification: Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        print(audioRouteChangeReason)
        
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
    
    func playNoteOn(channelNumber: Int) {
        let concertOffset = UserDefaults.standard.key().concertOffset
        let note = MIDINoteNumber(channelNumber + octaveConstant + concertOffset)
        bank.play(noteNumber: note, velocity: 127)
        channelsOn.append(channelNumber)
    }
    
    func playNoteOff(channelNumber: Int) {
        let concertOffset = UserDefaults.standard.key().concertOffset
        let note = MIDINoteNumber(channelNumber + octaveConstant + concertOffset)
        bank.stop(noteNumber: note)
        if let index = channelsOn.index(of: channelNumber) {
            channelsOn.remove(at: index)
        }
    }
    
    func incrementOctave() {
        let concertOffset = UserDefaults.standard.key().concertOffset
        let oldOctaveConstant = octaveConstant
        octaveConstant += 12
        setAttackReleaseDurationZero()
        for channel in channelsOn {
            let oldNote = MIDINoteNumber(channel + oldOctaveConstant + concertOffset)
            bank.stop(noteNumber: oldNote)
            let newNote = MIDINoteNumber(channel + octaveConstant + concertOffset)
            bank.play(noteNumber: newNote, velocity: 127)
        }
        resetAttackReleaseDuration()
    }
    
    func decrementOctave() {
        let concertOffset = UserDefaults.standard.key().concertOffset
        let oldOctaveConstant = octaveConstant
        octaveConstant -= 12
        setAttackReleaseDurationZero()
        for channel in channelsOn {
            let oldNote = MIDINoteNumber(channel + oldOctaveConstant + concertOffset)
            bank.stop(noteNumber: oldNote)
            let newNote = MIDINoteNumber(channel + octaveConstant + concertOffset)
            bank.play(noteNumber: newNote, velocity: 127)
        }
        resetAttackReleaseDuration()
    }
    
    private func setAttackReleaseDurationZero() {
        bank.attackDuration = 0.0
        bank.releaseDuration = 0.0
    }
    
    private func resetAttackReleaseDuration() {
        bank.attackDuration = 0.06
        bank.releaseDuration = 0.06
    }
    
    func setPitchStandard() {
        let pitchStandard = UserDefaults.standard.pitchStandard()
        bank.detuningMultiplier = pitchStandard / 440
    }
}
