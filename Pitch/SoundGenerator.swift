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
    private var octaveConstant: Int = 60
    private var channelsOn: [Int] = [] {
        didSet {
            Constants.pitchPipeIsPlayingSound = channelsOn.count > 0
        }
    }
    
    var tuner: Tuner!
    
    final func setUp() {
        self.mixer = AKMixer(tuner.silence)
        
        bank = AKOscillatorBank(waveform: AKTable(.triangle), attackDuration: 0.06, releaseDuration: 0.06)
        mixer.connect(bank)
        
        AudioKit.output = mixer
        AudioKit.start()
    }
    
    final func playNoteOn(channelNumber: Int) {
        let concertOffset = UserDefaults.standard.key().concertOffset
        bank.play(noteNumber: channelNumber + octaveConstant + concertOffset, velocity: 127)
        channelsOn.append(channelNumber)
    }
    
    final func playNoteOff(channelNumber: Int) {
        let concertOffset = UserDefaults.standard.key().concertOffset
        bank.stop(noteNumber: channelNumber + octaveConstant + concertOffset)
        if let index = channelsOn.index(of: channelNumber) {
            channelsOn.remove(at: index)
        }
    }
    
    final func incrementOctave() {
        let concertOffset = UserDefaults.standard.key().concertOffset
        let oldOctaveConstant = octaveConstant
        octaveConstant += 12
        setAttackReleaseDurationZero()
        for channel in channelsOn {
            bank.stop(noteNumber: channel + oldOctaveConstant + concertOffset)
            bank.play(noteNumber: channel + octaveConstant + concertOffset, velocity: 127)
        }
        resetAttackReleaseDuration()
    }
    
    final func decrementOctave() {
        let concertOffset = UserDefaults.standard.key().concertOffset
        let oldOctaveConstant = octaveConstant
        octaveConstant -= 12
        setAttackReleaseDurationZero()
        for channel in channelsOn {
            bank.stop(noteNumber: channel + oldOctaveConstant + concertOffset)
            bank.play(noteNumber: channel + octaveConstant + concertOffset, velocity: 127)
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
