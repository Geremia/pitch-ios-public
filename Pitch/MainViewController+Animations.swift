//
//  MainViewController+Animations.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/28/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import UICountingLabel
import Crashlytics

extension MainViewController {
    
    // MARK: - Animations
    
    func updateUI(output: TunerOutput) {
        if output.isValid {
            displayPitch(pitch: output.pitch.description)
            updateCentsLabel(offset: output.centsDistance)
            updateOctaveLabel(octave: output.pitch.octave)
            updateMovingLine(centsDistance: output.centsDistance)
            setViewToNewState(basedOnCentsDistance: output.centsDistance)
        } else {
            setViewTo(newState: .outOfTune)
            resetMovingLine()
        }
        
        UIView.animate(withDuration: 0.08, delay: 0, options: [.allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func updateCentsLabel(offset: Double) {
        centsLabel.isHidden = false
        
        let threshold = UserDefaults.standard.difficulty().tuningThreshold
        if abs(offset) < threshold {
            centsLabel.text = state == .inTune ? "You got it!" : "Hold it..."
        } else {
            let cents = abs(offset.roundTo(places: 1))
            let sharpOrFlat = offset > 0 ? "sharp" : "flat"
            centsLabel.text = "\(cents) cents \(sharpOrFlat)"
        }
    }
    
    func updateOctaveLabel(octave: Int) {
        octaveLabel.isHidden = false
        octaveLabel.text = String(octave)
    }
    
    func updateMovingLine(centsDistance: Double) {
        portraitMovingLineCenterConstraint.constant = abs(centsDistance) > 1 ? CGFloat(-centsDistance * 5.0) : 0.0
        
        if state != .inTune {
            movingLineHeight.constant = CGFloat(max(1, abs(centsDistance)))
            for height in self.tickmarkHeights {
                height.constant = self.state.lineThickness
            }
            
            let mainLineColor: UIColor = UserDefaults.standard.darkModeOn() ? .white : .black
            let intermediateColor = UIColor.orange
            let outOfTuneColor = UIColor.red
            
            // Functions for intensity based on cents distance. Got these through trial and error.
            let mainColorIntensity = CGFloat(-1 * pow(0.5 * abs(centsDistance), 2) + 50)
            let intermediateIntensity = CGFloat(-1 * pow(0.4 * abs(centsDistance) - 8, 2) + 50)
            let outOfTuneColorIntensity = CGFloat(-1 * pow(0.25 * abs(centsDistance) - 10, 2) + 50)
            
            let colors = [mainLineColor, intermediateColor, outOfTuneColor]
            let intensities = [mainColorIntensity, intermediateIntensity, outOfTuneColorIntensity]
            
            for component in movingLineComponents {
                component.backgroundColor = UIColor.blend(colors: colors, withIntensities: intensities)
            }
        }
    }
    
    func resetMovingLine() {
        updateMovingLine(centsDistance: Double(-portraitMovingLineCenterConstraint.constant / 5.0))
    }
    
    func setViewToNewState(basedOnCentsDistance centsDistance: Double) {
        let threshold = UserDefaults.standard.difficulty().tuningThreshold
        
        switch abs(centsDistance) {
        case 0...threshold:
            if state != .inTune {
                setViewTo(newState: .holding)
            }
        case threshold...threshold + 5.0:
            setViewTo(newState: .almostInTune)
        default:
            setViewTo(newState: .outOfTune)
        }
    }
    
    func setViewTo(newState: MainViewState) {
        if newState != state {
            state = newState
            transitionViewTo(newState: newState, animated: true)
        }
    }
    
    func transitionViewTo(newState: MainViewState, animated: Bool) {
        let options: UIViewAnimationOptions = [.transitionCrossDissolve, .beginFromCurrentState, .allowUserInteraction]
        let duration: TimeInterval = animated ? 0.2 : 0
        
        UIView.transition(with: self.noteLabel, duration: duration, options: options, animations: {
            self.noteLabel.textColor = newState.lineTextColor
            self.noteLabel.font = newState.font
            self.centsLabel.textColor = newState.lineTextColor
            self.centsLabel.font = newState.centsLabelFont
            self.octaveLabel.textColor = newState.lineTextColor
            self.octaveLabel.font = newState.octaveLabelFont
            self.analyticsCircle.circleLayer.strokeColor = newState.lineTextColor.cgColor
            self.analyticsCircle.circleLayer.lineWidth = newState.analyticsCircleThickness
            
            if self.noteLabel.text != "--" {
                self.displayPitch(pitch: (self.noteLabel.text?.trimmingCharacters(in: .whitespaces))!)
            }
        }, completion: { _ in })
        
        UIView.transition(with: self.sessionsButton, duration: duration, options: options, animations: {
            self.sessionsButton.setImage(newState.microphoneImage, for: .normal)
        }, completion: { _ in })
        
        UIView.transition(with: self.settingsButton, duration: duration, options: options, animations: {
            self.settingsButton.setImage(newState.menuImage, for: .normal)
        }, completion: { _ in })
        
        UIView.transition(with: self.pitchPipeButton, duration: duration, options: options, animations: {
            let image = self.pitchPipeOpen ? newState.closePitchPipeImage : newState.pitchPipeImage
            self.pitchPipeButton.setImage(image, for: .normal)
        }, completion: { _ in })
        
        UIView.transition(with: self.analyticsButton, duration: duration, options: options, animations: {
            self.analyticsButton.setImage(newState.analyticsImage, for: .normal)
        }, completion: { _ in })
        
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
            self.view.backgroundColor = newState.viewBackgroundColor
            for view in self.buttonBackgrounds {
                view.backgroundColor = newState.viewBackgroundColor
            }
            for line in self.tickmarks {
                line.backgroundColor = newState.lineTextColor
            }
            for component in self.movingLineComponents {
                component.backgroundColor = newState.lineTextColor
            }
        }, completion: { finished in
            if finished {
                if self.state == .inTune {
                    self.movingLineHeight.constant = newState.lineThickness
                    for height in self.tickmarkHeights {
                        height.constant = newState.lineThickness
                    }
                }
            }
        })
    }
    
    func displayPitch(pitch: String) {
        if pitch.characters.count > 1 {
            let font = noteLabel.font
            let fontSuper:UIFont? = noteLabel.font.withSize(38.0)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: pitch, attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName:fontSuper!, NSBaselineOffsetAttributeName:48], range: NSRange(location:1,length:1))
            
            let displayMode = UserDefaults.standard.displayMode()
            switch displayMode {
            case .sharps:
                noteLabel.setAttributedText(attString, withSpacing: -2.0)
            case .flats:
                noteLabel.setAttributedText(attString, withSpacing: -7.0)
            }
        } else {
            noteLabel.attributedText = NSMutableAttributedString(string: pitch + " ", attributes: nil)
        }
    }
    
    func updateAnalyticsCircle() {
        let label = UICountingLabel()
        label.formatBlock = { score -> String! in
            self.analyticsCircle.score = Double(score)
            return "\(Int(score))"
        }
        
        let percentage = DataManager.today().dataPercentage * 100
        if percentage < 100 {
            UIView.animate(withDuration: 0.3, animations: {
                self.analyticsButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        } else {
            shouldUpdateAnalyticsCircle = false
            
            analyticsMessage.layer.anchorPoint = CGPoint(x: 0.8, y: 1.0)
            analyticsMessage.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            
            label.completionBlock = { _ in
                self.analyticsCircle.isHidden = true
                Answers.logCustomEvent(withName: "Popup Appeared", customAttributes: nil)
                self.snapContainer?.resetAnalyticsVC()
                if Constants.currentOrientation == .portrait {
                    self.showPopup()
                }
            }
        }
        
        label.count(from: CGFloat(analyticsCircle.score), to: CGFloat(percentage), withDuration: 1.0)
    }
    
    func showPopup() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.analyticsButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.analyticsMessage.alpha = 1.0
            self.analyticsMessage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    func hidePopup() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            self.analyticsMessage.alpha = 0.0
        }, completion: nil)
    }
}
