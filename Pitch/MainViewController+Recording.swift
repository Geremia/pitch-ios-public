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
        recordViewTopConstraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.tunerView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func startRecording() {
        recordingState = .recording
        leftRecordButton.setTitle("Stop", for: .normal)
        // ANIMATE TO NEW POSITION
        
        // START RECORDING
    }
    
    func stopRecording() {
        recordingState = .doneRecording
        leftRecordButton.setTitle("Save", for: .normal)
        rightRecordButton.setTitle("Discard", for: .normal)
        // ANIMATE TO NEW POSITION
        
        // STOP RECORDING
    }
    
    func saveRecording() {
        recordingState = .notRecording
        resetRecordView()
        // SAVE RECORDING
    }
    
    func cancelRecording() {
        recordingState = .notRecording
        resetRecordView()
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
