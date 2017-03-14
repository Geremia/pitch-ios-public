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
    var recorder: AKNodeRecorder!
    var booster: AKBooster!
    
//    private var player: AKAudioPlayer?
    
    // MARK: - Initializers
    
    private override init() {
        AKAudioFile.cleanTempDirectory()
        AKSettings.bufferLength = .medium
        try! AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
        
        let microphone = AKMicrophone()
        let mixer = AKMixer(microphone)
        booster = AKBooster(mixer)
        booster.gain = 0.0
        
        recorder = try? AKNodeRecorder(node: mixer)
        
        super.init()
        
//        player = recorder?.audioFile?.player
    }
    
    // MARK: - Methods
    
    func startRecording() {
        try? recorder?.record()
    }
    
    func stopRecording() {
        recorder?.stop()
    }
    
    func saveCurrentRecording(_ completion: @escaping (AKAudioFile?, Error?) -> Void) {
        guard let audio = recorder?.audioFile else { return }
        
        audio.exportAsynchronously(name: "file.m4a", baseDir: .documents, exportFormat: .m4a, callback: { processedFile, error in
            completion(processedFile, error)
        })
        
//        try! player?.reloadFile()
//        player?.play()
    }
    
    func deleteCurrentRecording() {
        //
    }
    
    func reset() {
        try! recorder?.reset()
//        player = recorder?.audioFile?.player
    }
}
