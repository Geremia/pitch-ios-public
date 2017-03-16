//
//  MainViewController+Recording.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/3/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

extension MainViewController {
    
    // MARK: - Recording
    
    func prepareForRecording() {
        recordingState = .ready
        recordViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func startRecording() {
        if recordingState == .ready {
            sessionAnalytics = SessionAnalytics()
            Recorder.shared.startRecording()
        } else {
            Recorder.shared.resumeRecording()
        }
        
        recordingState = .recording
        leftRecordButton.setTitle("Pause", for: .normal)

        leftRecordButtonConstraint.constant = 15
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 0.0
        }, completion: nil)
        
        startAnimatingRecordLabel()
    }
    
    func cancelRecording() {
        recordingState = .notRecording
        resetRecordView()
        NotificationCenter.default.post(name: .recordingCancelled, object: nil)
    }
    
    func pauseRecording() {
        recordingState = .paused
        leftRecordButton.setTitle("Resume", for: .normal)
        rightRecordButton.setTitle("Done", for: .normal)
        
        leftRecordButtonConstraint.constant = 100
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 1.0
        }, completion: nil)
        
        stopAnimatingRecordLabel()
        Recorder.shared.pauseRecording()
    }
    
    func doneRecording() {
        recordingState = .notRecording
        Recorder.shared.stopRecording()
        NotificationCenter.default.post(name: .newSessionRecorded, object: session)
        
        if let container = snapContainer {
            guard let analytics = self.sessionAnalytics else { return }
            let session = Session(withRecordedFileUrl: Recorder.shared.currentFileUrl, analytics: analytics)
            container.go(toViewController: .sessions, animated: true, completion: {
                self.resetRecordView()
                self.resetSessionAnalytics()
            })
        }
    }
    
    func resetSessionAnalytics() {
        sessionAnalytics = nil
    }
    
    // MARK: - Record View
    
    func startAnimatingRecordLabel() {
        recordLabel.text = "Recording 00:00"
        recordLabelUpdateLink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    func updateRecordLabel() {
        let time: String = Recorder.shared.currentTime.prettyString
        let text = recordingState == .recording ? "Recording" : "Recorded"
        recordLabel.text = "\(text) \(time)"
    }
    
    func stopAnimatingRecordLabel() {
        updateRecordLabel()
        recordLabelUpdateLink.remove(from: .current, forMode: .defaultRunLoopMode)
    }
    
    func resetRecordView() {
        recordViewTopConstraint.constant = -recordView.frame.height
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: { finished in
            self.recordLabel.text = "Ready to record"
            self.leftRecordButton.setTitle("Start", for: .normal)
            self.rightRecordButton.setTitle("Cancel", for: .normal)
        })
    }
}

enum MainViewRecordingState {
    case notRecording
    case ready
    case recording
    case paused
}
