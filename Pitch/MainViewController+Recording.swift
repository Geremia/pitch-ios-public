//
//  MainViewController+Recording.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/3/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

extension MainViewController: SessionsViewControllerDelegate {
    
    // MARK: - Recording
    
    func prepareForRecording() {
        recordingState = .ready
        recordViewTopConstraint.constant = 0
        sessionsButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func startRecording() {
        recordingState = .recording
        leftRecordButton.setTitle("Stop", for: .normal)
        
        sessionAnalytics = SessionAnalytics()
        
        leftRecordButtonConstraint.constant = 15
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 0.0
        }, completion: nil)
        
        startAnimatingRecordLabel()
        Recorder.shared.startRecording()
    }
    
    func cancelRecording() {
        recordingState = .notRecording
        resetRecordView()
    }
    
    func stopRecording() {
        recordingState = .doneRecording
        leftRecordButton.setTitle("Save", for: .normal)
        rightRecordButton.setTitle("Discard", for: .normal)
        
        leftRecordButtonConstraint.constant = 100
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 1.0
        }, completion: nil)
        
        stopAnimatingRecordLabel()
        Recorder.shared.stopRecording()
    }
    
    func saveRecording() {
        recordingState = .notRecording
        resetRecordView()
        
        guard let analytics = self.sessionAnalytics else { return }
        let session = Session(withRecordedFileUrl: Recorder.shared.currentFileUrl, analytics: analytics)
        self.presentSessionsViewController(with: session)
        self.resetSessionAnalytics()
    }
    
    func discardRecording() {
        cancelRecording()
        Recorder.shared.deleteCurrentRecording()
    }
    
    func presentSessionsViewController(with session: Session) {
        let sessionsVC = self.sessionsVC()
        sessionsVC.session = session
        self.present(sessionsVC, animated: true, completion: nil)
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
        sessionsButton.isUserInteractionEnabled = true
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
    case doneRecording
}
