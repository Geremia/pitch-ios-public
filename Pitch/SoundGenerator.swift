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
    private var bank: AKOscillatorBank!
    private var mixer: AKMixer!
    private var octaveConstant: Int = 81
    private var channelsOn: [Int] = []
    
    var tuner: Tuner!
    
    final func setUp() {
        self.mixer = AKMixer(tuner.silence)
        
        bank = AKOscillatorBank(waveform: AKTable(.triangle), attackDuration: 0.06, releaseDuration: 0.06)
        mixer.connect(bank)
        AudioKit.output = mixer
        AudioKit.start()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        } catch let error {
            print(error)
        }
    }
    
    final func playNoteOn(channelNumber: Int) {
        bank.play(noteNumber: channelNumber + octaveConstant, velocity: 127)
        channelsOn.append(channelNumber)
    }
    
    final func playNoteOff(channelNumber: Int) {
        bank.stop(noteNumber: channelNumber + octaveConstant)
        if let index = channelsOn.index(of: channelNumber) {
            channelsOn.remove(at: index)
        }
    }
    
    final func incrementOctave() {
        let oldOctaveConstant = octaveConstant
        octaveConstant += 12
        setAttackReleaseDurationZero()
        for channel in channelsOn {
            bank.stop(noteNumber: channel + oldOctaveConstant)
            bank.play(noteNumber: channel + octaveConstant, velocity: 127)
        }
        resetAttackReleaseDuration()
    }
    
    final func decrementOctave() {
        let oldOctaveConstant = octaveConstant
        octaveConstant -= 12
        setAttackReleaseDurationZero()
        for channel in channelsOn {
            bank.stop(noteNumber: channel + oldOctaveConstant)
            bank.play(noteNumber: channel + octaveConstant, velocity: 127)
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
}
