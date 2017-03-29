//
//  AnalyticsViewController+Setup.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import RealmSwift
import Crashlytics
import ScrollableGraphView

extension AnalyticsViewController {
    
    // MARK: - Load Data
    
    func setDataToDisplay() {
        if let session = session {
            data = session.analytics
            showingSessionData = true
        } else {
            data = DataManager.today()
        }
    }
    
    func checkForShareAndAnimation() {
        showingSessionData ? sessionViewAppeared() : todayViewAppeared()
    }
    
    func todayViewAppeared() {
        data = DataManager.today()
        let defaults = UserDefaults.standard
        if data.hasSufficientData && defaults.analyticsOn() {
            if defaults.shouldShowAnalyticsSharePrompt() {
                showShareView()
            } else if !hasSeenAnimation() {
                startAnimation()
            }
        }
    }
    
    func sessionViewAppeared() {
        let defaults = UserDefaults.standard
        if defaults.shouldShowAnalyticsSharePrompt() {
            showShareView()
        } else if !hasSeenAnimation() {
            startAnimation()
        }
    }
    
    func showShareView() {
        showingShareView = true
        if !shareView.isHidden { return }
        UIView.transition(with: view, duration: 0.3, options: [.transitionCrossDissolve], animations: {
            self.shareView.isHidden = false
        }, completion: nil)
    }
    
    func startAnimation() {
        prepareForAnimation()
        animateIn()
        if showingSessionData {
            DataManager.setHasSeenAnalyticsAnimation(true, forSession: self.session!)
        } else {
            UserDefaults.standard.setHasSeenAnalyticsAnimation(true)
        }
    }
    
    // MARK: - Setup
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadAnalyticsData, object: nil)
    }
    
    func setupUI() {
        resetButton.layer.cornerRadius = 8.0
        resetButton.backgroundColor = UIColor.lighterRed
        
        darkModeChanged()
        setupGraphView()
        
        let showingSharePrompt = UserDefaults.standard.shouldShowAnalyticsSharePrompt()
        if showingSessionData {
            setupViewsForSessionAnalytics()
            setLabelTitlesForSessionAnalytics()
            
            if !showingSharePrompt {
                showingData = true
                reloadData()
            }
        } else {
            if data.hasSufficientData && !showingSharePrompt && UserDefaults.standard.analyticsOn() {
                showingData = true
                reloadData()
            }
        }
    }
    
    func setupViewsForSessionAnalytics() {
        tuningScoreLabel.isHidden = true
        tuningScoreSeparator.isHidden = true
        graphView.isHidden = true
        for line in graphReferenceLines {
            line.isHidden = true
        }
        for label in graphLabels {
            label.isHidden = true
        }
        for view in graphSideMargins {
            view.isHidden = true
        }
        resetButton.isHidden = true
        
        graphViewBottomConstraint.constant = -400
    }
    
    func setLabelTitlesForSessionAnalytics() {
        analyticsLabel.text = session?.name
        todayLabel.text = "This Session"
        tutorial1Label.text = "This is your score for this session. It tells you how good your tuning was overall."
    }
    
    func hasSeenAnimation() -> Bool {
        if showingSessionData {
            return (session?.analytics?.hasSeenAnimation)!
        } else {
            return UserDefaults.standard.hasSeenAnalyticsAnimation()
        }
    }
    
    func reloadData() {
        setDataToDisplay()
        updateEmptyState()
        setupScoreCircle()
        setupDescriptionLabel()
        pitchesTableViewController?.pitchOffsets = data.filteredPitchOffsets
        
        if !hasSeenAnimation() {
            prepareForAnimation()
        }
    }
    
    func updateEmptyState() {
        if showingSessionData {
            noDataView.isHidden = true
            helpButton.isHidden = false
        } else {
            noDataView.isHidden = data.hasSufficientData
            helpButton.isHidden = !data.hasSufficientData && !showingShareView
        }
    }
    
    func setupScoreCircle() {
        let score = data.tuningScore
        scoreLabel.text = "\(Int(score))"
        scoreCircle.colorful = true
        
        if hasSeenAnimation() {
            scoreCircle.score = Double(score)
            scoreCircle.setNeedsDisplay()
        }
    }
    
    func setupDescriptionLabel() {
        let boldFont = UIFont(name: "Lato-Regular", size: 17.0)!
        let lightFont = UIFont(name: "Lato-Light", size: 17.0)!
        let percentage = data.inTunePercentage.roundTo(places: 2) * 100
        let time = data.timeToCenter.roundTo(places: 1)
        
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
        let pastThirtyDays = DataManager.data(forPastDaysIncludingToday: 30)
        let data: [Double] = pastThirtyDays.map({ Double($0.tuningScore) })
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        var labels: [String] = pastThirtyDays.map({ dateFormatter.string(from: $0.date) })
        labels.removeLast()
        labels.append("Today")
        
        graphView.set(data: data, withLabels: labels)
        
        graphView.dataPointSpacing = (view.frame.width - 50) / clamp(CGFloat(data.count), lower: 2, upper: 30)
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
        graphView.dataPointFillColor = lineTextColor
        graphView.lineColor = darkModeOn ? .darkInTune : .inTune
        
        for view in graphSideMargins {
            view.backgroundColor = darkModeOn ? .darkGrayView : .white
        }
        
        for line in graphReferenceLines {
            line.backgroundColor = darkModeOn ? .darkSeparatorColor : .separatorColor
        }
        
        for label in graphLabels {
            label.textColor = lineTextColor
        }
        
        feedbackLabel.textColor = lineTextColor
    }
}
