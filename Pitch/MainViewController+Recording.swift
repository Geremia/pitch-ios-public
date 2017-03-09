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
                let sessions = self.sessionsVC()
//                sessions.audioFileUrl = processedFile?.url
                sessions.audioFileUrl = Recorder.sharedInstance.file?.url
                self.present(sessions, animated: true, completion: nil)
            }
        })
    }
    
    func cancelRecording() {
        recordingState = .notRecording
        resetRecordView()
        
        Recorder.sharedInstance.deleteCurrentRecording()
        Recorder.sharedInstance.reset()
    }
    
    // MARK: - Record View
    
    func startAnimatingRecordLabel() {
        recordLabelUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            let time: String = (Recorder.sharedInstance.recorder?.recordedDuration.prettyString)!
            self.recordLabel.text = "Recording \(time)"
        })
    }
    
    func stopAnimatingRecordLabel() {
        recordLabelUpdateTimer?.invalidate()
        recordLabelUpdateTimer = nil
        
        let time: String = (Recorder.sharedInstance.recorder?.recordedDuration.prettyString)!
        recordLabel.text = "Recorded \(time)"
    }
    
    func resetRecordView() {
        recordLabel.text = "Ready to record"
        leftRecordButton.setTitle("Start", for: .normal)
        rightRecordButton.setTitle("Cancel", for: .normal)
        
        recordViewTopConstraint.constant = -recordView.frame.height
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
}

enum MainViewRecordingState {
    case notRecording
    case ready
    case recording
    case doneRecording
}
