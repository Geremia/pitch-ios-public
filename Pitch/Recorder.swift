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
    
    func setupRecorder() {
        let recordSettings: [String : Any] = [AVSampleRateKey: 44100.0,
                              AVFormatIDKey: kAudioFormatAppleLossless,
                              AVNumberOfChannelsKey: 2,
                              AVEncoderAudioQualityKey: AVAudioQuality.max];
        
        var error: NSError?
        
        do {
            recorder =  try AVAudioRecorder(url: getFileURL(), settings: recordSettings)
        } catch let error1 as NSError {
            error = error1
            recorder = nil
        }
        
        if let err = error {
            print("AVAudioRecorder error: \(err.localizedDescription)")
        } else {
            recorder.delegate = self
            recorder.prepareToRecord()
        }
    }
    
    // MARK: - Actions
    
    func startRecording() {
        setupRecorder()
        recorder.record()
    }
    
    func stopRecording() {
        recorder.stop()
    }
    
    // MARK: - File URL
    
    func getFileURL() -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        let path = documentDirectory.appending(newFileName())
        let filePath = URL(fileURLWithPath: path)
        return filePath
    }
    
    private func newFileName() -> String {
        let number = UserDefaults.standard.fileNumber()
        return "file\(number).caf"
    }
    
    // MARK: - AVAudioRecorder delegate methods
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
}
