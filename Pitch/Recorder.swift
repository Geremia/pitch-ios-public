//
//  Recorder.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/4/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AVFoundation

class Recorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
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
            print("AVAudioRecorder error: \(error.localizedDescription)")
            recorder = nil
            return false
        }
        
        recorder.delegate = self
        recorder.prepareToRecord()
        return true
    }
    
    // MARK: - Prepare AVPlayer
    
    func preparePlayer() {
        var error: Error?
        var soundPlayer: AVAudioPlayer?
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: recorder.url)
        } catch let error1 {
            error = error1
            soundPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.volume = 1.0
            soundPlayer?.play()
        }
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
        preparePlayer()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    // MARK: - AVAudioPlayerDelegate Methods
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let success = flag ? "successfully" : "not successfully"
        print("finished playing \(success)")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
}
