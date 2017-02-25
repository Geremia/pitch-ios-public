//
//  AnalyticsViewController+Setup.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import ScrollableGraphView

extension AnalyticsViewController {
    
    // MARK: - Setup
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        resetButton.layer.cornerRadius = 8.0
        resetButton.backgroundColor = UIColor.lighterRed
        
        darkModeChanged()
        setupGraphView()
        
        let today = DataManager.today()
        let showingSharePrompt = UserDefaults.standard.shouldShowAnalyticsSharePrompt()
        if today.hasSufficientData && !showingSharePrompt && UserDefaults.standard.analyticsOn() {
            displayData()
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    func displayData() {
        noDataView.isHidden = true
        helpButton.isHidden = false
        
        setupScoreCircle()
        setupDescriptionLabel()
        
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
        let pastSevenDays = DataManager.data(forPastDaysIncludingToday: 30)
        let data: [Double] = pastSevenDays.map({ Double($0.tuningScore) })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var labels: [String] = pastSevenDays.map({ dateFormatter.string(from: $0.date) })
        labels.removeLast()
        labels.append("Today")
        
        graphView.set(data: data, withLabels: labels)
        
        graphView.dataPointSpacing = (view.frame.width - 50) / clamp(value: CGFloat(data.count), lower: 2, upper: 30)
        graphView.dataPointLabelFont = UIFont(name: "Lato-Regular", size: 15.0)!
        graphView.backgroundFillColor = UIColor.clear
        graphView.shouldDrawDataPoint = data.count == 1
        
        switch data.count {
        case 0...3:
            graphView.dataPointLabelsSparsity = 1
        case 3...7:
            graphView.dataPointLabelsSparsity = 2
        case 7...12:
            graphView.dataPointLabelsSparsity = 3
        case 12...16:
            graphView.dataPointLabelsSparsity = 4
        default:
            graphView.dataPointLabelsSparsity = 5
        }
        
        if data.count <= 2 {
            graphView.rightmostPointPadding = view.frame.width / CGFloat(data.count + 1)
        }
    }

    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        
        noDataView.backgroundColor = darkModeOn ? .darkGrayView : .white
        noDataImageView.image = darkModeOn ? #imageLiteral(resourceName: "line_chart_darkgray") : #imageLiteral(resourceName: "line_chart_lightgray")
        noDataLabel.textColor = darkModeOn ? .darkGray : .lightGray
        
        view.backgroundColor = darkModeOn ? .darkGrayView : .white
        backButton.setImage(darkModeOn ? #imageLiteral(resourceName: "white_back_arrow") : #imageLiteral(resourceName: "back_arrow"), for: .normal)
        analyticsLabel.textColor = darkModeOn ? .white : .black
        helpButton.setImage(darkModeOn ? #imageLiteral(resourceName: "white_question_mark") : #imageLiteral(resourceName: "question_mark"), for: .normal)
        
        scoreCircle.resetForDarkMode()
        
        let lineTextColor: UIColor = darkModeOn ? .white : .black
        
        scoreLabel.textColor = lineTextColor
        todayLabel.textColor = lineTextColor
        todaySeparator.backgroundColor = lineTextColor
        descriptionLabel.textColor = lineTextColor
        
        outOfTuneLabel.textColor = lineTextColor
        outOfTuneSeparator.backgroundColor = lineTextColor
        
        tuningScoreLabel.textColor = lineTextColor
        tuningScoreSeparator.backgroundColor = lineTextColor
        
        graphView.dataPointLabelColor = lineTextColor
        graphView.lineColor = darkModeOn ? .darkInTune : .inTune
        
        for view in graphSideMargins {
            view.backgroundColor = darkModeOn ? .darkGrayView : .white
        }
        
        for line in graphReferenceLines {
            line.backgroundColor = darkModeOn ? .darkPitchPipeBackground : .separatorColor
        }
        
        for label in graphLabels {
            label.textColor = lineTextColor
        }
        
        feedbackLabel.textColor = lineTextColor
    }
}
