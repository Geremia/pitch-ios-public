//
//  AnalyticsViewController+Setup.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

extension AnalyticsViewController {
    
    // MARK: - Setup
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        updateDarkMode()
        
        feedbackButton.layer.cornerRadius = 8.0
        
        let today = DataManager.today()
        let showingSharePrompt = UserDefaults.standard.shouldShowAnalyticsSharePrompt()
        if today.hasSufficientData && !showingSharePrompt {
            displayData()
        }
    }
    
    func displayData() {
        noDataView.isHidden = true
        helpButton.isHidden = false
        
        setupScoreCircle()
        setupDescriptionLabel()
        setupGraphView()
        
        if !UserDefaults.standard.hasSeenAnalyticsAnimation() {
            prepareForAnimation()
        }
    }
    
    func setupScoreCircle() {
        let today = DataManager.today()
        let score = today.tuningScore
        scoreLabel.text = "\(Int(score))"
        scoreCircle.colorful = true
        
        if UserDefaults.standard.hasSeenAnalyticsAnimation() {
            scoreCircle.score = Double(score)
            scoreCircle.setNeedsDisplay()
        }
    }
    
    func setupDescriptionLabel() {
        let boldFont = UIFont(name: "Lato-Regular", size: 17.0)!
        let lightFont = UIFont(name: "Lato-Light", size: 17.0)!
        let percentage = DataManager.today().inTunePercentage.roundTo(places: 2) * 100
        let time = DataManager.today().timeToCenter.roundTo(places: 1)
        
        let percentageString: NSAttributedString = NSAttributedString(string: "\(Int(percentage))%", attributes: [NSFontAttributeName: boldFont])
        let timeString: NSAttributedString = NSAttributedString(string: "\(time) seconds", attributes: [NSFontAttributeName: boldFont])
        
        let descriptionString: NSMutableAttributedString = NSMutableAttributedString(string: "You were in tune ", attributes: [NSFontAttributeName: lightFont])
        descriptionString.append(percentageString)
        descriptionString.append(NSAttributedString(string: " of the time, and you took ", attributes: [NSFontAttributeName: lightFont]))
        descriptionString.append(timeString)
        descriptionString.append(NSAttributedString(string: " on average to center the pitch.", attributes: [NSFontAttributeName: lightFont]))
        
        descriptionLabel.attributedText = descriptionString
    }
    
    func setupGraphView() {
        let pastSevenDays = DataManager.data(forPastDaysIncludingToday: 7)
        let data: [Double] = pastSevenDays.map({ Double($0.tuningScore) })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var labels: [String] = pastSevenDays.map({ dateFormatter.string(from: $0.date) })
        labels.removeLast()
        labels.append("Today")
        
        graphView.set(data: data, withLabels: labels)
        
        graphView.dataPointSpacing = view.frame.width / min(CGFloat(data.count), 5)
        graphView.dataPointLabelFont = UIFont(name: "Lato-Regular", size: 15.0)!
        graphView.backgroundFillColor = UIColor.clear
    }

    
}
