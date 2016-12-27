//
//  MainViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/14/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, TunerDelegate {
    
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
    
    // MARK: - Pitch Pipe Outlets
    
    @IBOutlet weak var pitchPipeView: PitchPipeView!
    @IBOutlet weak var pitchPipeBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Tuner Variables
    
    private var tuner: Tuner?
    
    var presentAniamtionController = VerticalSlideAnimationController(direction: .left)
    var dismissAnimationController = VerticalSlideAnimationController(direction: .right)
    
    var isPitchPipeOpen: Bool = false
    var state: MainViewState = .outOfTune
    
    // MARK: - Analytics Variables
    
    var today: Day = UserDefaults.standard.today()
    var addedCurrentCenterTime: Bool = false
    var pitchStartTime: Date?
    var pitchCenterTimer: Timer?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTuner()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pitchPipeView.updateButtonLabels()
    }
    
    func setupTuner() {
        tuner = Tuner()
        tuner?.delegate = self
        self.pitchPipeView.soundGenerator.tuner = tuner
        self.pitchPipeView.soundGenerator.setUp()
        tuner?.start()
    }
    
    func setupUI() {
        self.pitchPipeBottomConstraint.constant = -231
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.darkModeChanged), name: .darkModeChanged, object: nil)
        darkModeChanged()
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        state = .outOfTune
        animateViewTo(newState: .outOfTune)
        
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.transition(with: self.view, duration: 0.2, options: [.transitionCrossDissolve, .allowUserInteraction], animations: {
                self.view.isHidden = false
            }, completion: nil)
        }
    }
    
    // MARK: TunerDelegate Methods
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        amplitudeLabel.text = "Amplitude: \(output.amplitude)"
        stdDevLabel.text = "Std. Dev: \(output.standardDeviation)"
        
        updateUI(output: output)
        addOutputToAnalytics(output: output)
        updatePitchCenterTimer(output: output)
    }
    
    // MARK: - Actions
    
    @IBAction func pitchPipePressed(_ sender: AnyObject) {
        let image = isPitchPipeOpen ? state.audioWaveImage : state.downArrowImage
        pitchPipeButton.setImage(image, for: .normal)
        pitchPipeBottomConstraint.constant = isPitchPipeOpen ? -231 : 0
        
        isPitchPipeOpen = !isPitchPipeOpen
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.2, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
     }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
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

