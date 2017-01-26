//
//  AnalyticsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/24/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI
import UICountingLabel
import ScrollableGraphView

class AnalyticsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var analyticsLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
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
    @IBOutlet weak var outOfTuneTable: UIView!
    @IBOutlet weak var outOfTuneTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var outOfTuneLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var outOfTuneSeparatorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var outOfTuneTableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tuningScoreLabel: UILabel!
    @IBOutlet weak var tuningScoreSeparator: UIView!
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet var graphReferenceLines: [UIView]!
    @IBOutlet var graphLabels: [UILabel]!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackButton: UIButton!
    
    @IBOutlet weak var tutorial1: UIView!
    @IBOutlet weak var tutorial2: UIView!
    @IBOutlet weak var tutorial3: UIView!
    
    // MARK: - Variables
    
    var hasShownShareView: Bool = false
    var tutorialState: Int = 1
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if DataManager.today().hasSufficientData {
            let defaults = UserDefaults.standard
            if defaults.shouldShowAnalyticsSharePrompt() && !hasShownShareView {
                hasShownShareView = true
                performSegue(withIdentifier: "analyticsToShare", sender: nil)
            } else if !defaults.hasSeenAnalyticsAnimation() {
                animateIn()
                UserDefaults.standard.setHasSeenAnalyticsAnimation(true)
            }
        }
    }
    
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
            helpButton.setImage(#imageLiteral(resourceName: "white_question_mark"), for: .normal)
            
            scoreCircle.backgroundColor = .darkGrayView
            scoreLabel.textColor = UIColor.white
            todayLabel.textColor = .white
            todaySeparator.backgroundColor = .white
            descriptionLabel.textColor = .white
            
            outOfTuneLabel.textColor = .white
            outOfTuneSeparator.backgroundColor = .white
            
            tuningScoreLabel.textColor = .white
            tuningScoreSeparator.backgroundColor = .white
            
            graphView.dataPointLabelColor = .white
            graphView.lineColor = .darkInTune
            
            for line in graphReferenceLines {
                line.backgroundColor = .darkPitchPipeBackground
            }
            
            for label in graphLabels {
                label.textColor = .white
            }
            
            feedbackLabel.textColor = .white
            feedbackButton.backgroundColor = .darkInTune
        }
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        tutorialState = 1
        startTutorial()
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "analyticsToShare" {
            let shareVC: ShareViewController = segue.destination as! ShareViewController
            shareVC.delegate = self
        } else if segue.identifier == "pitchesTableEmbed" {
            let pitchesVC: PitchesTableViewController = segue.destination as! PitchesTableViewController
            pitchesVC.delegate = self
        }
    }
}

extension AnalyticsViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AnalyticsViewController: ShareViewControllerDelegate {
    
    // MARK: - ShareViewControllerDelegate Methods
    
    func userDidShare() {
        displayData()
    }
}

extension AnalyticsViewController: PitchesTableViewControllerDelegate {
    
    // MARK: - PitchesTableViewControllerDelegate Methods
    
    func setNumberOfRows(_ rows: Int) {
        outOfTuneTableHeightConstraint.constant = 44.0 * CGFloat(rows)
        view.layoutIfNeeded()
    }
}
