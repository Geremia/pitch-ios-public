//
//  TuningFork.swift
//  TuningFork
//
//  Copyright (c) 2015 Comyar Zaheri. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//


// MARK:- Imports

import AudioKit

// MARK:- TunerDelegate Protocol

/**
 Types adopting the TunerDelegate protocol act as callbacks for Tuners and are
 the mechanism by which you may receive and respond to new information decoded
 by a Tuner.
 */
protocol TunerDelegate {
    
    /**
     Called by a Tuner on each update.
     
     - parameter tuner: Tuner that performed the update.
     - parameter output: Contains information decoded by the Tuner.
     */
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput)
}

// MARK:- TunerOutput

/**
 Contains information decoded by a Tuner, such as frequency, octave, pitch, etc.
 */
class TunerOutput: NSObject {
    
    /**
     The octave of the interpreted pitch.
     */
    open fileprivate(set) var pitch: Pitch = Pitch.all.first!
    
    /**
     The difference between the frequency of the interpreted pitch and the actual
     frequency of the microphone audio.
     
     For example if the microphone audio has a frequency of 432Hz, the pitch will
     be interpreted as A4 (440Hz), thus making the distance -8Hz.
     */
    open fileprivate(set) var distance: Double = 0.0
    
    /**
     The difference between the frequency of the interpreted pitch and the actual
     frequency of the microphone audio in cents
     */
    open fileprivate(set) var centsDistance: Double = 0.0
    
    /**
     The amplitude of the microphone audio.
     */
    open fileprivate(set) var amplitude: Double = 0.0
    
    /**
     The frequency of the microphone audio.
     */
    open fileprivate(set) var frequency: Double = 0.0
    
    /**
     The standard deviation of the last 10 detected frequencies
     */
    open fileprivate(set) var standardDeviation: Double = 0.0
    
    /**
     Whether the frequency is determined to be an actual note or just random background noise.
    */
    open fileprivate(set) var isValid: Bool = false
    
    fileprivate override init() {}
}


// MARK:- Tuner

/**
 A Tuner uses the devices microphone and interprets the frequency, pitch, etc.
 */
class Tuner: NSObject {
    
    fileprivate let updateInterval: TimeInterval = 0.01
    fileprivate let smoothingBufferCount = 30
    fileprivate let frequencyBufferCount = 20
    
    /**
     Object adopting the TunerDelegate protocol that should receive callbacks
     from this tuner.
     */
    var delegate: TunerDelegate?
    
    fileprivate let threshold: Double
    fileprivate var smoothing: Float
    let microphone: AKMicrophone
    let analyzer: AKFrequencyTracker
    var silence: AKBooster
    fileprivate var timer: Timer?
    fileprivate var smoothingBuffer: [Double] = []
    fileprivate var frequencyBuffer: [Double] = []
    fileprivate var previousAmplitude: Double
    fileprivate var previousFrequency: Double
    
    /**
     Initializes a new Tuner.
     
     - parameter threshold: The minimum amplitude to recognize, 0 < threshold < 1
     - parameter smoothing: Exponential smoothing factor, 0 < smoothing < 1
     
     */
    public init(threshold: Double = 0.0, smoothing: Float = 0.075) {
        self.threshold = min(abs(threshold), 1.0)
        self.smoothing = min(abs(smoothing), 1.0)
        self.previousAmplitude = 0.0
        self.previousFrequency = 0.0
        microphone = AKMicrophone()
        analyzer = AKFrequencyTracker(microphone, hopSize: 512, peakCount: 100)
        silence = AKBooster(analyzer, gain: 0.0)
    }
    
    func audioRouteChanged(_ notification: Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            DispatchQueue.main.async {
                self.checkForExternalMic(askPermission: true)
            }
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            DispatchQueue.main.async {
                self.switchToInternalMic()
            }
        default:
            break
        }
    }
    
    func checkForExternalMic(askPermission: Bool) {
        for input in AKSettings.session.availableInputs! {
            if input.portType == "MicrophoneWired" {
                askPermission ? askForExternalMicPermission() : switchToExternalMic()
            }
        }
    }
    
    func askForExternalMicPermission() {
        let alert = UIAlertController(title: "External Microphone Detected", message: "Pitch has detected an external microphone. Want to use it for tuning?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.switchToExternalMic()
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func switchToExternalMic() {
        AudioKit.stop()
        try! microphone.setDevice(AKDevice(name: "Headset Microphone", deviceID: "Wired Microphone"))
        AudioKit.start()
    }
    
    func switchToInternalMic() {
        AudioKit.stop()
        try! microphone.setDevice(AKDevice(name: "iPhone Microphone", deviceID: "Built-In Microphone"))
        try! AKSettings.session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        AudioKit.start()
    }
    
    /**
     Starts the tuner.
     */
    open func start() {
        checkForExternalMic(askPermission: false)
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChanged(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        timer = Timer.scheduledTimer(timeInterval: updateInterval, target: self, selector: #selector(Tuner.timerAction), userInfo: nil, repeats: true)
    }
    
    /**
     Stops the tuner.
     */
    open func stop() {
        print("stop tuner")
        microphone.stop()
        analyzer.stop()
        timer?.invalidate()
        timer = nil
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Called every time the timer refreshes.
     */
    func timerAction() {
        if let d = self.delegate {
            let amplitude = self.analyzer.amplitude
            var frequency = self.analyzer.frequency
            
            if amplitude - previousAmplitude > 0.05 || abs(frequency - previousFrequency) > (distanceBetweenNotes(frequency: frequency) / 2) {
                self.smoothing = 1.0
                self.smoothingBuffer.removeAll()
            } else if smoothingBuffer.count < smoothingBufferCount {
                self.smoothing = 0.3
            } else {
                self.smoothing = 0.017
            }
            previousAmplitude = amplitude
            previousFrequency = frequency
            
            addFrequencyToBuffer(frequency)
            frequency = self.smooth(frequency)
            let standardDeviation = self.standardDeviation(arr: frequencyBuffer)
            
            let output = Tuner.newOutput(frequency, amplitude, standardDeviation)
            DispatchQueue.main.async {
                d.tunerDidUpdate(self, output: output)
            }
        }
    }
    
    /**
     The distance between the two pitches closest to a given frequency.
     */
    func distanceBetweenNotes(frequency: Double) -> Double {
        let pitch = Pitch.nearest(frequency: frequency)
        let lowerPitch = pitch - 1
        return pitch.frequency - lowerPitch.frequency
    }
    
    fileprivate func addFrequencyToBuffer(_ value: Double) {
        if frequencyBuffer.count > frequencyBufferCount {
            frequencyBuffer.removeFirst()
        }
        frequencyBuffer.append(value)
    }
    
    /**
     Exponential smoothing:
     https://en.wikipedia.org/wiki/Exponential_smoothing
     */
    fileprivate func smooth(_ value: Double) -> Double {
        var frequency = value
        if smoothingBuffer.count > 0 {
            let last = smoothingBuffer.last!
            frequency = (smoothing * value) + (1.0 - smoothing) * last
            if smoothingBuffer.count > smoothingBufferCount {
                smoothingBuffer.removeFirst()
            }
        }
        smoothingBuffer.append(frequency)
        return frequency
    }
    
    static func newOutput(_ frequency: Double, _ amplitude: Double, _ standardDeviation: Double) -> TunerOutput {
        let output = TunerOutput()
        
        let pitch = Pitch.nearest(frequency: frequency)
        output.distance = frequency - pitch.frequency
        output.centsDistance = 1200 * log2(frequency/pitch.frequency)
        
        output.frequency = frequency
        output.amplitude = amplitude
        output.standardDeviation = standardDeviation
        
        let concertOffset = UserDefaults.standard.key().concertOffset
        output.pitch = pitch - concertOffset

        let amplitudeThreshold = UserDefaults.standard.micSensitivity().amplitudeThreshold
        output.isValid = standardDeviation < 10.0 && amplitude > amplitudeThreshold && frequency > 20.0
        
        return output
    }
    
    func standardDeviation(arr : [Double]) -> Double {
        let length = Float(arr.count)
        let avg = arr.reduce(0, {$0 + $1}) / length
        let sumOfSquaredAvgDiff = arr.map { pow($0 - avg, 2.0)}.reduce(0, {$0 + $1})
        return sqrt(sumOfSquaredAvgDiff / length)
    }
}
