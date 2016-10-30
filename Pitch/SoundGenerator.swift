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
    var oscillators = [AKOscillator]()
    var tuner: Tuner!
    var mixer: AKMixer!
    
    final func setUp() {
        let pitches = Pitch.octaveOnePitches
        for pitch in pitches {
            let oscillator = AKOscillator(waveform: AKTable(.triangle, size: 4096))
            oscillator.frequency = pitch.frequency()
            oscillator.amplitude = 0.0
            oscillator.rampTime = 0.05
            oscillators.append(oscillator)
        }
        
        self.mixer = AKMixer(tuner.silence, oscillators[0])
        AudioKit.output = mixer
        AudioKit.start()
        
//        oscillators[0].start()
    }
    
    final func playNoteOn(channelNumber: Int) {
        let oscillator = oscillators[channelNumber]
        oscillator.amplitude = 1.0
        oscillator.play()
    }
    
    final func playNoteOff(channelNumber: Int) {
        let oscillator = oscillators[channelNumber]
        oscillator.amplitude = 0.0
    }
}


//class Synth: AKInstrument {
//    
//    var frequency = AKInstrumentProperty(value: 0,  minimum: 0, maximum: 4000)
//    var amplitude = AKInstrumentProperty(value: 0,  minimum: 0, maximum: 1.0)
//    
//    override init() {
//        super.init()
//        
//        addProperty(frequency)
//        addProperty(amplitude)
//        
//        let oscillator = AKOscillator()
//        
//        oscillator.frequency = frequency
//        oscillator.amplitude = amplitude
//        oscillator.waveform = AKTable.standardTriangleWave()
//        
//        connect(oscillator)
//        connect(AKAudioOutput(audioSource: oscillator))
//    }
//}
