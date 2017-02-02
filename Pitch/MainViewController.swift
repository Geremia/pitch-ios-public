//
//  MainViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/14/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit
import Crashlytics

class MainViewController: UIViewController {
    
    // MARK: - Tuner Outlets
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var centsLabel: UILabel!
    @IBOutlet weak var octaveLabel: UILabel!
    @IBOutlet var lines: [UIView]!
    @IBOutlet var lineHeights: [NSLayoutConstraint]!
    @IBOutlet var portraitElements: [UIView]!
    @IBOutlet weak var portraitMovingLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var stdDevLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var pitchPipeButton: UIButton!
    
    @IBOutlet weak var analyticsButton: UIButton!
    @IBOutlet weak var analyticsCircle: ScoreCircle!
    @IBOutlet weak var analyticsMessage: UIImageView!
    
    @IBOutlet weak var audioPlot: EZAudioPlot!
    
    // MARK: - Pitch Pipe Outlets
    
    @IBOutlet weak var pitchPipeView: PitchPipeView!
    @IBOutlet weak var pitchPipeBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Tuner Variables
    
    var tuner: Tuner?
    var tunerSetup: Bool = false
    
    var presentAniamtionController = VerticalSlideAnimationController(direction: .left)
    var dismissAnimationController = VerticalSlideAnimationController(direction: .right)
    
    var pitchPipeOpen: Bool = false
    var state: MainViewState = .outOfTune
    
    var shouldUpdateAnalyticsCircle = true
    
    var plot: AKNodeOutputPlot!
    
    // MARK: - Analytics Variables
    
    var today: Day!
    var addedCurrentCenterTime: Bool = false
    var pitchStartTime: Date?
    var pitchCenterTimer: Timer?
    
    // MARK: - Other Variables
    
    var snapContainer: SnapContainerViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        today = DataManager.today()
        
        setupNotifications()
        checkRecordPermission()
        setupUI()
        
//        setupPlot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pitchPipeView.updateButtonLabels()
        if today.hasSufficientData {
            analyticsMessage.alpha = 0.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if !tunerSetup {
//            checkRecordPermission()
//        }
    }
    
    // MARK: - Notifications
    
    func openToneGenerator() {
        if !pitchPipeOpen {
            openPitchPipe()
        }
    }
    
    func openAnalytics() {
        if presentedViewController == nil {
            performSegue(withIdentifier: "mainToAnalytics", sender: self)
        }
    }

    // MARK: - Audio Plot Action
    
    func plotTapped() {
        print("Plot tapped")
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
        }
        
        state = .outOfTune
        animateViewTo(newState: .outOfTune)
    }

    // MARK: - Actions
    
    @IBAction func pitchPipePressed(_ sender: AnyObject) {
        pitchPipeOpen ? closePitchPipe() : openPitchPipe()
    }
    
    func openPitchPipe() {
        pitchPipeOpen = true
        pitchPipeButton.setImage(state.downArrowImage, for: .normal)
        pitchPipeBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closePitchPipe() {
        pitchPipeOpen = false
        pitchPipeButton.setImage(state.audioWaveImage, for: .normal)
        pitchPipeBottomConstraint.constant = -231
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
        
        if segue.identifier == "mainToAnalytics" {
            Answers.logCustomEvent(withName: "Opened Analytics", customAttributes: ["afterPopup" : String(today.hasSufficientData)])
        }
     }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MainViewController: TunerDelegate {
    
    // MARK: TunerDelegate Methods
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        amplitudeLabel.text = "Amplitude: \(output.amplitude)"
        stdDevLabel.text = "Std. Dev: \(output.standardDeviation)"
        
        updateUI(output: output)
        addOutputToAnalytics(output: output)
        updatePitchCenterTimer(output: output)
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewControllerTransitioningDelegate Methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is SettingsViewController {
            return VerticalSlideAnimationController(direction: .left)
        } else {
            return VerticalSlideAnimationController(direction: .right)
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is SettingsViewController {
            return VerticalSlideAnimationController(direction: .right)
        } else {
            return VerticalSlideAnimationController(direction: .left)
        }
    }
}

