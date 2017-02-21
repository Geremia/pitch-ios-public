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
    
    @IBOutlet weak var audioPlot: EZAudioPlot!
    
    @IBOutlet var orientationDependentConstraints: [NSLayoutConstraint]!
    
    // MARK: - Pitch Pipe Outlets
    
    @IBOutlet weak var pitchPipeView: PitchPipeView!
    @IBOutlet weak var pitchPipeBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Tuner Variables
    
    var tunerSetup: Bool = false
    
    var pitchPipeOpen: Bool = false
    var state: MainViewState = .outOfTune
    
    var shouldUpdateAnalyticsCircle: Bool = true
    var shouldUpdateUI: Bool = true
    
    var plot: AKNodeOutputPlot!
    
    var currentOrientation: MainViewOrientation = .portrait
    
    // MARK: - Analytics Variables
    
    var today: Day!
    
    var previousPitchWasInTune: Bool = false
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraints(forSize: view.bounds.size, withTransitionCoordinator: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateConstraints(forSize: size, withTransitionCoordinator: coordinator)
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
        animateViewTo(newState: .outOfTune)
        resetMovingLine()
    }
    
    // MARK: - Orientation Switching
    
    func updateConstraints(forSize size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator?) {
        let orientation: MainViewOrientation = size.height > size.width ? .portrait : .landscape
        
        if orientation != currentOrientation && orientation != .unspecified {
            var constraints: NSArray = orientationDependentConstraints as NSArray
            constraints.autoRemoveConstraints()
            
            orientationDependentConstraints = orientation == .portrait ? portraitConstraints() : landscapeConstraints()
            constraints = orientationDependentConstraints as NSArray
            currentOrientation = orientation
            
            if let coordinator = coordinator {
                coordinator.animate(alongsideTransition: { context in
                    constraints.autoInstallConstraints()
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                constraints.autoInstallConstraints()
                view.layoutIfNeeded()
            }
        }
    }
    
    func portraitConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            settingsButton.autoPinEdge(toSuperviewMargin: .bottom)
            settingsButton.autoPinEdge(toSuperviewMargin: .left)
            pitchPipeButton.autoPinEdge(toSuperviewMargin: .bottom)
            pitchPipeButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            analyticsButton.autoPinEdge(toSuperviewMargin: .bottom)
            analyticsButton.autoPinEdge(toSuperviewMargin: .right)
        }
    }
    
    func landscapeConstraints() -> [NSLayoutConstraint] {
        return NSLayoutConstraint.autoCreateConstraintsWithoutInstalling {
            settingsButton.autoPinEdge(toSuperviewMargin: .bottom)
            settingsButton.autoPinEdge(toSuperviewMargin: .right)
            pitchPipeButton.autoPinEdge(toSuperviewMargin: .right)
            pitchPipeButton.autoAlignAxis(toSuperviewAxis: .vertical)
            analyticsButton.autoPinEdge(toSuperviewMargin: .top)
            analyticsButton.autoPinEdge(toSuperviewMargin: .right)
        }
    }

    // MARK: - Actions
    
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

enum MainViewOrientation {
    case portrait
    case landscape
    case unspecified
}

