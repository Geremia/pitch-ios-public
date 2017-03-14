//
//  Player.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/14/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class Player: NSObject, AVAudioPlayerDelegate {
    
    // MARK: - Properties
    
    static let sharedInstance: Player = Player()
    
    var player: AVAudioPlayer!
    var currentTime: TimeInterval = 0
    var updateLink: CADisplayLink?
    
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
        startSendingUpdates()
    }
    
    func startSendingUpdates() {
        updateLink = CADisplayLink(target: self, selector: #selector(sendUpdate))
        updateLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    func sendUpdate() {
        currentTime = player.currentTime
        NotificationCenter.default.post(name: .playbackUpdate, object: nil, userInfo: ["currentTime": currentTime])
    }
    
    func stopSendingUpdates() {
        updateLink?.remove(from: .current, forMode: .defaultRunLoopMode)
        updateLink = nil
    }
    
    func pause() {
        stopSendingUpdates()
        player.pause()
    }
    
    func reset() {
        stopSendingUpdates()
        player = nil
    }
    
    // MARK: - AVAudioPlayerDelegate Methods
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        reset()
        NotificationCenter.default.post(name: .finishedPlayback, object: nil)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio player error: \(error?.localizedDescription)")
    }
}
