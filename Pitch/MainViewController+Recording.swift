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
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func startRecording() {
        recordingState = .recording
        leftRecordButton.setTitle("Stop", for: .normal)
        
        sessionAnalytics = SessionAnalytics.makeNew()
        
        leftRecordButtonConstraint.constant = 15
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.recordView.layoutIfNeeded()
            self.rightRecordButton.alpha = 0.0
        }, completion: nil)
        
        startAnimatingRecordLabel()
        Recorder.sharedInstance.startRecording()
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
        Recorder.sharedInstance.stopRecording()
    }
    
    func saveRecording() {
        recordingState = .notRecording
        resetRecordView()
        
        Recorder.sharedInstance.saveCurrentRecording({ processedFile, error in
            if error == nil {
                print("New recording saved.")
            } else {
                print("Error saving new recording: \(error.debugDescription)")
            }
            
            DispatchQueue.main.async {
                guard let analytics = self.sessionAnalytics else { return }
                let session = Session.with(recordedFileUrl: (Recorder.sharedInstance.file?.url)!, andAnalytics: analytics)
                self.presentSessionsViewController(with: session)
                self.resetSessionAnalytics()
            }
        })
    }
    
    func cancelRecording() {
        recordingState = .notRecording
        resetRecordView()
        
        Recorder.sharedInstance.deleteCurrentRecording()
        Recorder.sharedInstance.reset()
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
        let time: String = (Recorder.sharedInstance.recorder?.recordedDuration.prettyString)!
        recordLabel.text = "Recording \(time)"
    }
    
    func stopAnimatingRecordLabel() {
        recordLabelUpdateLink.remove(from: .current, forMode: .defaultRunLoopMode)
        
        let time: String = (Recorder.sharedInstance.recorder?.recordedDuration.prettyString)!
        recordLabel.text = "Recorded \(time)"
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
    case doneRecording
}
