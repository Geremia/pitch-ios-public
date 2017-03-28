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

class AnalyticsViewController: SnapContainerChildViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareView: UIView!
    
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
    @IBOutlet weak var graphViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var graphReferenceLines: [UIView]!
    @IBOutlet var graphLabels: [UILabel]!
    @IBOutlet var graphSideMargins: [UIView]!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var tutorial1: UIView!
    @IBOutlet weak var tutorial1Label: UILabel!
    @IBOutlet weak var tutorial2: UIView!
    @IBOutlet weak var tutorial3: UIView!
    @IBOutlet weak var tutorial3HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tutorial4: UIView!
    
    // MARK: - Properties
    
    var data: Day!
    var session: Session?
    
    var showingSessionData: Bool = false
    var showingData: Bool = false
    var hasPreparedForAnimation: Bool = false
    var tutorialState: Int = 1
    
    var pitchesTableViewController: PitchesTableViewController?
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
            DataManager.resetToday()
            self.setDataToDisplay()
            self.snapContainer?.transitionLeft(animated: true, completion: {
                NotificationCenter.default.post(name: .resetAnalyticsData, object: nil)
                self.snapContainer?.resetAnalyticsVC()
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addActions([deleteAction, cancelAction])
        
        snapContainer?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Page Switching
    
    override func didBecomeCurrentPage() {
        checkForShareAndAnimation()
        Answers.logCustomEvent(withName: "Opened Analytics", customAttributes: ["afterPopup" : String(DataManager.today().hasSufficientData)])
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "analyticsToShare" || segue.identifier == "shareEmbed" {
            let shareVC: ShareViewController = segue.destination as! ShareViewController
            shareVC.delegate = self
        } else if segue.identifier == "pitchesTableEmbed" {
            pitchesTableViewController = segue.destination as? PitchesTableViewController
            pitchesTableViewController?.delegate = self
        }
    }
}
