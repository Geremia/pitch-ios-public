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
    var player: AVAudioPlayer!
    
    // MARK: - Setup
    
    private override init() {}

    // MARK: - Actions
    
    func play(from url: URL) {
        if let player = player {
            if player.url == url {
                player.play()
            } else {
                player.stop()
                loadAndPlay(from: url)
            }
        } else {
            loadAndPlay(from: url)
        }
    }
    
    private func loadAndPlay(from url: URL) {
        player = try! AVAudioPlayer(contentsOf: url)
        player.play()
    }
    
    func pause() {
        player.pause()
    }
}
