//
//  AnalyticsViewController+Animations.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/24/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

extension AnalyticsViewController {
    
    // MARK: - Orientation
    
    func orientationChanged(_ notification: Notification) {
        let orientation = UIDevice.current.orientation
        if orientation == .faceUp || orientation == .faceDown { return }
        if !showingData { return }
        
        let isPortrait = orientation == .portrait || orientation == .portraitUpsideDown
        UIView.transition(with: helpButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.helpButton.isHidden = !isPortrait
        }, completion: nil)
        
        endTutorial()
    }
    
    // MARK: - Animation
    
    func prepareForAnimation() {
        scoreCircle.transform = CGAffineTransform(scaleX: 0, y: 0)
        scoreCircle.alpha = 0.0
        
        scoreLabel.formatBlock = { score -> String! in
            self.scoreCircle.score = Double(score)
            return "\(Int(score))"
        }
        scoreLabel.text = "0"
        
        todayLabel.alpha = 0.0
        todaySeparator.alpha = 0.0
        descriptionLabel.alpha = 0.0
        outOfTuneLabel.alpha = 0.0
        outOfTuneSeparator.alpha = 0.0
        outOfTuneTable.alpha = 0.0
        
        let constraints = [todayLabelTopConstraint, todaySeparatorTopConstraint, descriptionLabelTopConstraint, outOfTuneLabelTopConstraint, outOfTuneSeparatorTopConstraint, outOfTuneTableTopConstraint]
        let increment = 100
        for i in 0..<constraints.count {
            let constraint = constraints[i]
            constraint?.constant += 250.0 + CGFloat(i * increment)
        }
        
        feedbackLabel.alpha = 0.0
        resetButton.alpha = 0.0
    }
    
    func animateIn() {
        let score = DataManager.today().tuningScore
        self.scoreLabel.countFromZero(to: CGFloat(score), withDuration: 1.2)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: [.curveEaseInOut], animations: {
            self.scoreCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.scoreCircle.alpha = 1.0
        }, completion: nil)
        
        let constraints = [todayLabelTopConstraint, todaySeparatorTopConstraint, descriptionLabelTopConstraint, outOfTuneLabelTopConstraint, outOfTuneSeparatorTopConstraint, outOfTuneTableTopConstraint]
        let increment = 100
        for i in 0..<constraints.count {
            let constraint = constraints[i]
            constraint?.constant -= 250.0 + CGFloat(i * increment)
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
            self.todayLabel.alpha = 1.0
            self.todaySeparator.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
            self.outOfTuneLabel.alpha = 1.0
            self.outOfTuneSeparator.alpha = 1.0
            self.outOfTuneTable.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.4, options: [], animations: {
            self.feedbackLabel.alpha = 1.0
            self.resetButton.alpha = 1.0
        }, completion: { _ in
            let shouldBypassTutorial = UserDefaults.standard.shouldBypassAnalyticsTutorial()
            if !shouldBypassTutorial {
                UserDefaults.standard.setShouldBypassAnalyticsTutorial(true)
                self.startTutorial()
            }
        })
    }
}
