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
    
    static let sharedInstance: Recorder = Recorder()
    var recorder: AVAudioRecorder!
    
    private override init() {}
    
    // MARK: - AVRecorder Setup
    
    func setupRecorder() -> Bool {
        let recordSettings: [String : Any] = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                              AVSampleRateKey: 44100,
                                              AVNumberOfChannelsKey: 2,
                                              AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue];
        
        do {
            recorder = try AVAudioRecorder(url: getFileURL(), settings: recordSettings)
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
        if setupRecorder() {
            recorder.record()
        }
    }
    
    func stopRecording() {
        recorder.stop()
    }
    
    func deleteCurrentRecording() {
        if !recorder.isRecording {
            do {
                try FileManager.default.removeItem(at: recorder.url)
            } catch let error {
                print("Delete recording error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - File URL
    
    func getFileURL() -> URL {
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
