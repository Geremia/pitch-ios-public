//
//  MainViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 9/14/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import TuningFork
import MessageUI

class MainViewController: UIViewController, MFMailComposeViewControllerDelegate, TunerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var feedbackButton: UIButton!
    
    // Tuner
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet var lines: [UIView]!
    @IBOutlet var lineHeights: [NSLayoutConstraint]!
    @IBOutlet var portraitElements: [UIView]!
    @IBOutlet var landscapeElements: [UIView]!
    @IBOutlet weak var portraitMovingLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var landscapeMovingLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var amplitudeLabel: UILabel!
    @IBOutlet weak var stdDevLabel: UILabel!
    @IBOutlet weak var pitchPipeButton: UIButton!
    
    // Pitch Pipe
    
    @IBOutlet weak var pitchPipeBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var movingLineCenterConstraint: NSLayoutConstraint {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            return portraitMovingLineCenterConstraint
        } else {
            return landscapeMovingLineCenterConstraint
        }
    }
    var isPitchPipeOpen: Bool = false
    
    private var tuner: Tuner?
    private var state: MainViewState = .White
    
    var today: Day = Day()
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pitchPipeBottomConstraint.constant = -231
        tuner = Tuner()
        tuner?.delegate = self
        tuner?.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI(for: UIApplication.shared.statusBarOrientation, animationDuration: 0)
    }
    
    // MARK: - Device Rotation
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        updateUI(for: toInterfaceOrientation, animationDuration: duration)
    }
    
    func updateUI(for orientation: UIInterfaceOrientation, animationDuration: TimeInterval) {
        UIView.animate(withDuration: animationDuration, animations: {
            if orientation.isPortrait {
                for element in self.landscapeElements {
                    element.alpha = 0.0
                }
                for element in self.portraitElements {
                    element.alpha = 1.0
                }
            } else {
                for element in self.landscapeElements {
                    element.alpha = 1.0
                }
                for element in self.portraitElements {
                    element.alpha = 0.0
                }
            }
        })
    }
    
    // MARK: TunerDelegate Methods
    
    func tunerDidUpdate(_ tuner: Tuner, output: TunerOutput) {
        amplitudeLabel.text = "Amplitude: \(output.amplitude)"
        stdDevLabel.text = "Std. Dev: \(output.standardDeviation)"
        
        updateUI(output: output)
        addOutputToAnalytics(output: output)
        updatePitchCenterTimer(output: output)
    }
    
    // MARK: - Analytics
    
    func addOutputToAnalytics(output: TunerOutput) {
        if output.isValid {
            today.addDataPoint(tunerOutput: output)
        }
    }
    
    var addedCurrentCenterTime: Bool = false
    var pitchStartTime: Date?
    var pitchCenterTimer: Timer?
    
    func updatePitchCenterTimer(output: TunerOutput) {
        if output.isValid {
            if pitchStartTime == nil {
                startTimingPitch()
            }
            
            if state == .Green {
                pitchCenterTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in
                    if !self.addedCurrentCenterTime {
                        self.addPitchCenterTimeToAnalytics()
                    }
                })
            }
        } else {
            stopTimingPitch()
            pitchStartTime = nil
        }
    }
    
    func startTimingPitch() {
        pitchStartTime = Date()
        addedCurrentCenterTime = false
    }
    
    func stopTimingPitch() {
        pitchCenterTimer?.invalidate()
        pitchCenterTimer = nil
        addedCurrentCenterTime = true
    }
    
    func addPitchCenterTimeToAnalytics() {
        if let time = self.pitchStartTime {
            let interval = Date().timeIntervalSince(time)
            today.addDataPoint(timeToCenter: interval)
            self.stopTimingPitch()
        }
    }
    
    // MARK: - UI
    
    func updateUI(output: TunerOutput) {
        if !output.isValid {
            noteLabel.attributedText = NSMutableAttributedString(string: "--", attributes: nil)
            movingLineCenterConstraint.constant = 0.0
            animateViewTo(newState: .White)
        } else {
            if noteLabel.text != output.pitch {
                displayPitch(pitch: output.pitch)
            }
            
            if UIApplication.shared.statusBarOrientation.isPortrait {
                movingLineCenterConstraint.constant = CGFloat(-output.distance * 30.0)
            } else {
                movingLineCenterConstraint.constant = CGFloat(output.distance * 30.0)
            }
            
            if abs(output.distance) < 0.4 {
                animateViewTo(newState: .Green)
            } else if abs(output.distance) < 1.5 {
                animateViewTo(newState: .LightGreen)
            } else {
                animateViewTo(newState: .White)
            }
        }
        
        if abs(movingLineCenterConstraint.constant) < 2.0 {
            movingLineCenterConstraint.constant = 0.0
        }
        
        UIView.animate(withDuration: 0.08, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func animateViewTo(newState: MainViewState) {
        if newState != state {
            state = newState
            
            var delay = 0.0
            if newState == .Green {
                delay = 1.0
            }
            
            let when = DispatchTime.now() + delay
            let stateBeforeDelay = state
            DispatchQueue.main.asyncAfter(deadline: when) {
                if stateBeforeDelay == self.state {
                    let font = self.state.font
                    UIView.transition(with: self.noteLabel, duration: 0.2, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
                        self.noteLabel.textColor = newState.lineTextColor
                        self.noteLabel.font = newState.font
                        self.displayPitch(pitch: self.noteLabel.text!)
                        }, completion: { _ in })
                    
                    UIView.transition(with: self.feedbackButton, duration: 0.2, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
                        self.feedbackButton.setImage(newState.feedbackImage, for: .normal)
                        }, completion: { _ in })
                    
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                        self.view.backgroundColor = newState.viewBackgroundColor
                        for line in self.lines {
                            line.backgroundColor = newState.lineTextColor
                        }
                        }, completion: { finished in
                            if finished {
                                for height in self.lineHeights {
                                    height.constant = newState.lineThickness
                                }
                                for line in self.lines {
                                    line.layoutIfNeeded()
                                }
                            }
                    })
                }
            }
        }
    }
    
    func displayPitch(pitch: String) {
        if pitch.characters.count > 1 {
            let font = noteLabel.font
            let fontSuper:UIFont? = noteLabel.font.withSize(45.0)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: pitch, attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName:fontSuper!, NSBaselineOffsetAttributeName:42], range: NSRange(location:1,length:1))
            noteLabel.attributedText = attString
        } else {
            noteLabel.attributedText = NSMutableAttributedString(string: pitch, attributes: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func feedbackPressed(_ sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["dkuntz0@gmail.com"])
            mail.setSubject("Pitch Tuner Feedback")
            mail.setMessageBody("Hi Daniel,\n This is how I think you can improve the Pitch tuner app: \n\n", isHTML: true)
            
            present(mail, animated: true, completion: nil)
        }
    }
    
    @IBAction func pitchPipePressed(_ sender: AnyObject) {
        if self.isPitchPipeOpen {
            self.pitchPipeBottomConstraint.constant = -231
            self.isPitchPipeOpen = false
            self.pitchPipeButton.setImage(#imageLiteral(resourceName: "audio_wave"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            self.pitchPipeBottomConstraint.constant = 0
            self.isPitchPipeOpen = true
            self.pitchPipeButton.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Analytics

extension MainViewController {
    
}

