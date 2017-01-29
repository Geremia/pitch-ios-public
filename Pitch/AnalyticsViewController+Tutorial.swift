//
//  AnalyticsViewController+Tutorial.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/21/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

extension AnalyticsViewController {
    
    // MARK: - Tutorial
    
    func startTutorial() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tutorialTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let top = CGRect(x: 0, y: 0, width: 1, height: 1)
        scrollView.scrollRectToVisible(top, animated: false)
        
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial1.isHidden = false
        }, completion: nil)
    }
    
    func tutorialTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        tutorialState += 1
        
        switch tutorialState {
        case 2:
            showTutorial2()
        case 3:
            showTutorial3()
        case 4:
            showTutorial4()
        default:
            endTutorial()
        }
    }
    
    func showTutorial2() {
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial1.isHidden = true
            self.tutorial2.isHidden = false
        }, completion: nil)
    }
    
    func showTutorial3() {
        var outOfTuneFrame = outOfTuneTable.frame
        outOfTuneFrame.origin.y += 60
        scrollView.scrollRectToVisible(outOfTuneFrame, animated: false)
        
        // Adjust size of overlay based on out-of-tune table view cell count
        let tableHeight = outOfTuneTable.frame.height
        let desiredCutoutHeight = tableHeight + 120
        tutorial3HeightConstraint.constant = CGFloat((2400 * desiredCutoutHeight) / 236)
        tutorial3.layoutIfNeeded()
        
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial2.isHidden = true
            self.tutorial3.isHidden = false
        }, completion: nil)
    }
    
    func showTutorial4() {
        var graphFrame = graphView.frame
        graphFrame.origin.y -= 60
        scrollView.scrollRectToVisible(graphFrame, animated: false)
        
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial3.isHidden = true
            self.tutorial4.isHidden = false
        }, completion: nil)
    }
    
    func endTutorial() {
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial4.isHidden = true
        }, completion: nil)
    }
}
