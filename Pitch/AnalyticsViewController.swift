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
    @IBOutlet var graphSideMargins: [UIView]!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackButton: UIButton!
    
    @IBOutlet weak var tutorial1: UIView!
    @IBOutlet weak var tutorial2: UIView!
    @IBOutlet weak var tutorial3: UIView!
    @IBOutlet weak var tutorial3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorial4: UIView!
    
    // MARK: - Variables
    
    var hasShownShareView: Bool = false
    var tutorialState: Int = 1
    
    var snapContainer: SnapContainerViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNotifications()
    }
    
    func checkForShareAndAnimation() {
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

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if let container = snapContainer {
            container.transitionLeft(animated: true)
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
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
