//
//  Recorder.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/4/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AVFoundation

class Recorder: NSObject, AVAudioRecorderDelegate {
    
    // MARK: - Properties
    
    private var recorder: AVAudioRecorder!
    
    var currentFileUrl: URL {
        return recorder.url
    }
    
    var currentTime: TimeInterval {
        return recorder.currentTime
    }
    
    // MARK: - Setup
    
    func setup() -> Bool {
        if let recorder = recorder {
            recorder.stop()
        }
        
        let recordSettings: [String : Any] = [AVFormatIDKey: NSNumber(value:Int32(kAudioFormatMPEG4AAC)),
                                              AVSampleRateKey: NSNumber(value: Float(44100.0)),
                                              AVNumberOfChannelsKey: NSNumber(value: Int32(2)),
                                              AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.max.rawValue))];
        
        do {
            recorder = try AVAudioRecorder(url: newFileURL(), settings: recordSettings)
        } catch let error {
            print("AVAudioRecorder setup error: \(error.localizedDescription)")
            recorder = nil
            return false
        }
        
        recorder.delegate = self
        recorder.prepareToRecord()
        return true
    }
    
    // MARK: - Actions
    
    func startRecording() {
        if setup() {
            recorder.record()
        }
    }
    
    func pauseRecording() {
        recorder.pause()
    }
    
    func resumeRecording() {
        recorder.record()
    }
    
    func stopRecording() {
        recorder.stop()
    }
    
    // MARK: - File URL
    
    private func newFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let filePath = documentDirectory.appendingPathComponent(newFileName(), isDirectory: true)
        return filePath
    }
    
    private func newFileName() -> String {
        let number = UserDefaults.standard.fileNumber()
        return "recording\(number).m4a"
    }
    
    // MARK: - AVAudioRecorderDelegate Methods
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        let success = flag ? "successfully" : "not successfully"
        print("finished recording \(success)")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
}
