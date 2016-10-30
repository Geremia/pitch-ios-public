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
    var oscillators = [Synth]()
    private var increasingAmplitude: Bool = false
    private var decreasingAmplitude: Bool = false
    
    final func setUp() {
        let pitches = Pitch.octaveOnePitches
        for pitch in pitches {
            let synth = Synth()
            synth.frequency.setValue(pitch.frequency(), forKey: "value")
            synth.amplitude.setValue(0.0, forKey: "value")
            AKOrchestra.add(synth)
            oscillators.append(synth)
            synth.play()
        }
        
        let displayLink = CADisplayLink(target: self, selector: #selector(SoundGenerator.updateAmplitude))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        AKOrchestra.start()
    }
    
    final func playNoteOn(channelNumber: Int) {
//        oscillators[channelNumber].play()
        self.increasingAmplitude = true
    }
    
    final func playNoteOff(channelNumber: Int) {
//        oscillators[channelNumber].amplitude.setValue(0.0, forKey: "value")
        self.decreasingAmplitude = true
    }
    
    func updateAmplitude() {
        if self.increasingAmplitude {
            var amplitude = oscillators[0].amplitude.value
            amplitude += 0.1
            
            if amplitude > 1.0 {
                amplitude = 1.0
                self.increasingAmplitude = false
            }
            
            oscillators[0].amplitude.setValue(amplitude, forKey: "value")
        } else if self.decreasingAmplitude {
            var amplitude = oscillators[0].amplitude.value
            amplitude -= 0.08
            
            if amplitude < 0.0 {
                amplitude = 0.0
                self.decreasingAmplitude = false
            }
            
            oscillators[0].amplitude.setValue(amplitude, forKey: "value")
        }
    }
}


class Synth: AKInstrument {
    
    var frequency = AKInstrumentProperty(value: 0,  minimum: 0, maximum: 4000)
    var amplitude = AKInstrumentProperty(value: 0,  minimum: 0, maximum: 1.0)
    
    override init() {
        super.init()
        
        addProperty(frequency)
        addProperty(amplitude)
        
        let oscillator = AKOscillator()
        
        oscillator.frequency = frequency
        oscillator.amplitude = amplitude
        oscillator.waveform = AKTable.standardTriangleWave()
        
        connect(oscillator)
        connect(AKAudioOutput(audioSource: oscillator))
    }
}
