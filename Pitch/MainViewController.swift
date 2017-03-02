//
//  MainViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/14/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit
import PureLayout

class MainViewController: UIViewController {
    
    // MARK: - Tuner Outlets
    
    @IBOutlet weak var tunerView: UIView!
    @IBOutlet var buttonBackgrounds: [UIView]!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var centsLabel: UILabel!
    @IBOutlet weak var octaveLabel: UILabel!
    
    @IBOutlet var tickmarks: [UIView]!
    @IBOutlet var tickmarkHeights: [NSLayoutConstraint]!
    
    @IBOutlet weak var movingLineHeight: NSLayoutConstraint!
    @IBOutlet weak var portraitMovingLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet var movingLineComponents: [UIView]!
    
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var stdDevLabel: UILabel!
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var pitchPipeButton: UIButton!
    
    @IBOutlet weak var analyticsButton: UIButton!
    @IBOutlet weak var analyticsCircle: ScoreCircle!
    @IBOutlet weak var analyticsMessage: UIImageView!
    
    @IBOutlet weak var pitchPipeView: PitchPipeView!
    
    // MARK: - Tuner Variables
    
    var tunerSetup: Bool = false
    
    var pitchPipeOpen: Bool = false
    var state: MainViewState = .outOfTune
    
    var shouldUpdateAnalyticsCircle: Bool = true
    var shouldUpdateUI: Bool = true
    
    var plot: AKNodeOutputPlot!
    
    var orientationDependentConstraints: [NSLayoutConstraint] = []
    var pitchPipeDisplayConstraint: NSLayoutConstraint!
    var didSetupConstraints: Bool = false
    
    // MARK: - Analytics Variables
    
    var previousPitchWasInTune: Bool = false
    var pitchStartTime: Date?
    var pitchCenterTimer: Timer?
    
    // MARK: - Other Variables
    
    var snapContainer: SnapContainerViewController?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        checkRecordPermission()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pitchPipeView.updateButtonLabels()
        if DataManager.today().hasSufficientData {
            analyticsMessage.alpha = 0.0
        }
    }
    
    // MARK: - Notifications
    
    func openToneGenerator() {
        if !pitchPipeOpen {
            openPitchPipe()
        }
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
        }
        
        state = .outOfTune
        transitionViewTo(newState: .outOfTune, animated: false)
        resetMovingLine()
    }

    // MARK: - Actions
    
    @IBAction func sessionsPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sessionsVC = storyboard.instantiateViewController(withIdentifier: "sessions")
        sessionsVC.transitioningDelegate = self
        present(sessionsVC, animated: true, completion: nil)
    }
    
    @IBAction func settingsPressed(_ sender: Any) {
        if let container = snapContainer {
            container.transitionLeft(animated: true)
        }
    }
    
    @IBAction func pitchPipePressed(_ sender: AnyObject) {
        pitchPipeOpen ? closePitchPipe() : openPitchPipe()
    }
    
    @IBAction func analyticsPressed(_ sender: Any) {
        if let container = snapContainer {
            container.transitionRight(animated: true)
        }
    }
    
    // MARK: - Pitch Pipe
    
    func openPitchPipe() {
        pitchPipeOpen = true
        updatePitchPipeButtonImage()
        pitchPipeDisplayConstraint.constant = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closePitchPipe() {
        pitchPipeOpen = false
        updatePitchPipeButtonImage()
        pitchPipeDisplayConstraint.constant = Constants.currentOrientation == .portrait ? 231 : 260
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func updatePitchPipeButtonImage() {
        let image: UIImage = pitchPipeOpen ? state.closePitchPipeImage : state.pitchPipeImage
        pitchPipeButton.setImage(image, for: .normal)
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
        
        if shouldUpdateUI {
            updateUI(output: output)
            addOutputToAnalytics(output: output)
            updatePitchCenterTimer(output: output)
        }
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(direction: .above)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimationController(direction: .below)
    }
}
