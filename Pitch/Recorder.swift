//
//  Recorder.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/4/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import Foundation
import AudioKit

class Recorder: NSObject {
    
    static let sharedInstance: Recorder = Recorder()
    
    var file: AKAudioFile?
    var recorder: AKNodeRecorder?
    
    private override init() {
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = dirPaths[0].appendingPathComponent("sound.caf")
        let settings: [String : Any] = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                                              AVEncoderBitRateKey: 16,
                                              AVNumberOfChannelsKey: 2,
                                              AVSampleRateKey: 44100.0]
        
        file = try? AKAudioFile(forWriting: url, settings: settings)
        recorder = try? AKNodeRecorder(node: Tuner.sharedInstance.microphone, file: file)
    }
    
    private func newFileName() -> String {
        let number = UserDefaults.standard.fileNumber()
    }
    
    func startRecording() {
        try? recorder?.record()
    }
    
    func stopRecording() {
        try? recorder?.stop()
    }
    
}
