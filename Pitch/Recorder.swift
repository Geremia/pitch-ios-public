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
    
    // MARK: - Properties
    
    static let sharedInstance: Recorder = Recorder()
    
    var file: AKAudioFile?
    var recorder: AKNodeRecorder?
    
    // MARK: - Initializers
    
    private override init() {}
    
    // MARK: - Methods
    
    func startRecording() {
        recorder = try? AKNodeRecorder(node: Tuner.sharedInstance.microphone)
        file = recorder?.audioFile
        
        try? recorder?.record()
    }
    
    func stopRecording() {
        recorder?.stop()
    }
    
    func saveCurrentRecording(_ completion: @escaping (AKAudioFile?, Error?) -> Void) {
        guard let file = recorder?.audioFile else { return }
        
        file.exportAsynchronously(name: "TestTempFile.caf", baseDir: .documents, exportFormat: .caf, callback: { processedFile, error in
            completion(processedFile, error)
        })
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
