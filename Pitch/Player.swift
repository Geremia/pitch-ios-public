//
//  Player.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/14/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class Player: NSObject {
    
    // MARK: - Properties
    
    static let sharedInstance: Player = Player()
    var player: AKAudioPlayer!
    
    // MARK: - Setup
    
    private override init() {
        player = try! AKAudioPlayer(file: AKAudioFile())
        super.init()
    }

    // MARK: - Actions
    
    func play(_ audioFile: AKAudioFile) {
        if player.audioFile == audioFile {
            player.resume()
        } else {
            player.stop()
            try! player.replace(file: audioFile)
            player.completionHandler = finishedPlaying
            player.play()
        }
    }
    
    func pause() {
        player.pause()
    }
    
    private func finishedPlaying() {
        DispatchQueue.main.async {
            //
        }
    }
}
