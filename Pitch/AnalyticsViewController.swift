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
import Crashlytics

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
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var tutorial1: UIView!
    @IBOutlet weak var tutorial2: UIView!
    @IBOutlet weak var tutorial3: UIView!
    @IBOutlet weak var tutorial3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorial4: UIView!
    
    // MARK: - Properties
    
    var data: Day!
    var session: Session?
    
    var showingSessionData: Bool = false
    var showingData: Bool = false
    var hasShownShareView: Bool = false
    var tutorialState: Int = 1
    
    var snapContainer: SnapContainerViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataToDisplay()
        setupUI()
        setupNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showingSessionData {
            sessionViewAppeared()
        }
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if showingSessionData {
            dismiss(animated: true, completion: nil)
        } else if let container = snapContainer {
            container.transitionLeft(animated: true)
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        startTutorial()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "This will delete all of your Analytics data for today only. Are you sure?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            Answers.logCustomEvent(withName: "Reset Analytics", customAttributes: nil)
            self.snapContainer?.transitionLeft(animated: true, completion: {
                DataManager.resetToday()
                NotificationCenter.default.post(name: .resetAnalyticsData, object: nil)
                self.snapContainer?.resetAnalyticsVC()
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addActions([deleteAction, cancelAction])
        
        snapContainer?.present(alert, animated: true, completion: nil)
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
