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
    
    // MARK: - Animation
    
    func prepareForAnimation() {
        scoreCircle.transform = CGAffineTransform(scaleX: 0, y: 0)
        scoreCircle.alpha = 0.0
        
        scoreLabel.formatBlock = { score -> String! in
            self.scoreCircle.score = Double(score)
            self.scoreCircle.setNeedsDisplay()
            return "\(Int(score))"
        }
        scoreLabel.text = "0"
        
        todayLabel.alpha = 0.0
        todaySeparator.alpha = 0.0
        descriptionLabel.alpha = 0.0
        
        todayLabelTopConstraint.constant += 250
        todaySeparatorTopConstraint.constant += 350
        descriptionLabelTopConstraint.constant += 450
    }
    
    func animateIn() {
        let score = DataManager.today().inTunePercentage.roundTo(places: 2) * 100
        self.scoreLabel.countFromZero(to: CGFloat(score), withDuration: 1.2)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: [.curveEaseInOut], animations: {
            self.scoreCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.scoreCircle.alpha = 1.0
        }, completion: nil)
        
        todayLabelTopConstraint.constant -= 250
        todaySeparatorTopConstraint.constant -= 350
        descriptionLabelTopConstraint.constant -= 450
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
            self.todayLabel.alpha = 1.0
            self.todaySeparator.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
        }, completion: nil)
    }
    
}
