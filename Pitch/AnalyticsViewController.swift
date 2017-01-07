//
//  AnalyticsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/24/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import UICountingLabel
import MessageUI

class AnalyticsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var analyticsLabel: UILabel!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataImageView: UIImageView!
    
    @IBOutlet weak var scoreCircle: ScoreCircle!
    @IBOutlet weak var scoreLabel: UICountingLabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todaySeparator: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var todayLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var todaySeparatorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var outOfTuneLabel: UILabel!
    @IBOutlet weak var outOfTuneSeparator: UIView!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackButton: UIButton!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        if !defaults.hasSeenAnalyticsAnimation() && DataManager.today().hasSufficientData {
            animateIn()
            UserDefaults.standard.setHasSeenAnalyticsAnimation(true)
        }
    }
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        updateDarkMode()
        
        feedbackButton.layer.cornerRadius = 8.0
        
        let today = DataManager.today()
        if today.hasSufficientData {
            displayData()
        }
    }
    
    func displayData() {
        noDataView.isHidden = true
        
        setupScoreCircle()
        setupDescriptionLabel()
        
        if !UserDefaults.standard.hasSeenAnalyticsAnimation() {
            prepareForAnimation()
        }
    }
    
    func setupScoreCircle() {
        let today = DataManager.today()
        let score = today.inTunePercentage.roundTo(places: 2) * 100
        scoreLabel.text = "\(Int(score))"
        
        if UserDefaults.standard.hasSeenAnalyticsAnimation() {
            scoreCircle.score = score
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
    
    // MARK: - Dark Mode Switching
    
    func updateDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            noDataView.backgroundColor = .darkGrayView
            noDataImageView.image = #imageLiteral(resourceName: "line_chart_darkgray")
            noDataLabel.textColor = .darkGray
            
            view.backgroundColor = .darkGrayView
            backButton.setImage(#imageLiteral(resourceName: "white_back_arrow"), for: .normal)
            analyticsLabel.textColor = .white
            scoreCircle.backgroundColor = .darkGrayView
            scoreLabel.textColor = UIColor.white
            todayLabel.textColor = .white
            todaySeparator.backgroundColor = .white
            descriptionLabel.textColor = .white
            
            outOfTuneLabel.textColor = .white
            outOfTuneSeparator.backgroundColor = .white
            
            feedbackLabel.textColor = .white
            feedbackButton.layer.backgroundColor = UIColor.darkInTune.cgColor
        }
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func feedbackButtonPressed(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["dkuntz0@gmail.com"])
            mail.setSubject("Pitch Tuner Feedback")
            mail.setMessageBody("Hi Daniel,\n This is how I think you can improve the Pitch tuner app: \n\n\n\n\n\n ", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        }
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension AnalyticsViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
