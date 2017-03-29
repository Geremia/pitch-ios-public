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
    
    fileprivate var player: AVAudioPlayer?
    fileprivate var currentTime: TimeInterval = 0
    fileprivate var timeToStartFrom: TimeInterval = 0
    fileprivate var updateLink: CADisplayLink?

    // MARK: - Actions
    
    func play(from url: URL) {
        guard let player = player else {
            loadAndPlay(from: url)
            return
        }
        
        if player.url == url {
            player.play()
            startSendingUpdates()
        } else {
            player.stop()
            loadAndPlay(from: url)
        }
    }
    
    fileprivate func loadAndPlay(from url: URL) {
        player = try! AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.currentTime = timeToStartFrom
        player?.play()
        startSendingUpdates()
    }
    
    func startSendingUpdates() {
        updateLink = CADisplayLink(target: self, selector: #selector(sendUpdate))
        updateLink?.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    func sendUpdate() {
        if let player = player {
            currentTime = player.currentTime
            NotificationCenter.default.post(name: .playbackUpdate, object: nil, userInfo: ["currentTime": currentTime])
        }
    }
    
    func stopSendingUpdates() {
        updateLink?.remove(from: .current, forMode: .defaultRunLoopMode)
        updateLink = nil
    }
    
    func setCurrentTime(_ time: TimeInterval) {
        if let player = player {
            player.currentTime = time
        } else {
            timeToStartFrom = time
        }
    }
    
    func pause() {
        stopSendingUpdates()
        guard let player = player else { return }
        player.pause()
    }
    
    func reset() {
        pause()
        currentTime = 0
        timeToStartFrom = 0
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
