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
    
    private override init() {}
    
    private func newFileName() -> String {
        let number = UserDefaults.standard.fileNumber()
        return "file\(number).caf"
    }
    
    func startRecording() {
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = dirPaths[0].appendingPathComponent(newFileName())
        let settings: [String : Any] = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                                        AVEncoderBitRateKey: 16,
                                        AVNumberOfChannelsKey: 2,
                                        AVSampleRateKey: 44100.0]
        
        file = try? AKAudioFile(forWriting: url, settings: settings)
        recorder = try? AKNodeRecorder(node: Tuner.sharedInstance.microphone, file: file)
        
        try? recorder?.record()
    }
    
    func stopRecording() {
        try? recorder?.stop()
    }
    
    func deleteCurrentRecording() {
        if let file = file {
            try? FileManager.default.removeItem(at: file.url)
        }
    }
    
    func reset() {
        file = nil
        recorder = nil
    }
}
