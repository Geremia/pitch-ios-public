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
        
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial2.isHidden = true
            self.tutorial3.isHidden = false
        }, completion: nil)
    }
    
    func endTutorial() {
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.tutorial3.isHidden = true
        }, completion: nil)
    }
}
