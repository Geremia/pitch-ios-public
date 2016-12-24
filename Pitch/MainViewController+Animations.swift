//
//  MainViewController+Animations.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/28/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    // MARK: - UI
    
    func updateUI(output: TunerOutput) {
        if !output.isValid {
            noteLabel.attributedText = NSMutableAttributedString(string: "--", attributes: nil)
            portraitMovingLineCenterConstraint.constant = 0.0
            centsLabel.isHidden = true
            octaveLabel.isHidden = true
            setViewTo(newState: .outOfTune)
        } else {
            if noteLabel.text != output.pitch {
                displayPitch(pitch: output.pitch)
            }
            
            centsLabel.isHidden = false
            updateCentsLabel(offset: output.centsDistace)
            octaveLabel.isHidden = false
            octaveLabel.text = String(output.octave)
            
            let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
            portraitMovingLineCenterConstraint.constant = CGFloat(isPortrait ? -output.distance * 30.0 : output.distance * 30.0)
            
            switch abs(output.distance) {
            case 0...0.4:
                setViewTo(newState: .inTune)
            case 0.4...1.5:
                setViewTo(newState: .almostInTune)
            default:
                setViewTo(newState: .outOfTune)
            }
        }
        
        if abs(portraitMovingLineCenterConstraint.constant) < 2.0 {
            portraitMovingLineCenterConstraint.constant = 0.0
        }
        
        UIView.animate(withDuration: 0.08, delay: 0, options: [.allowUserInteraction], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setViewTo(newState: MainViewState) {
        if newState != state {
            state = newState
            let delay = newState == .inTune ? 1.0 : 0.0
            
            let when = DispatchTime.now() + delay
            let stateBeforeDelay = state
            DispatchQueue.main.asyncAfter(deadline: when) {
                if stateBeforeDelay == self.state {
                    self.animateViewTo(newState: newState)
                }
            }
        }
    }
    
    func animateViewTo(newState: MainViewState) {
        let options: UIViewAnimationOptions = [.transitionCrossDissolve, .beginFromCurrentState, .allowUserInteraction]
        
        UIView.transition(with: self.noteLabel, duration: 0.2, options: options, animations: {
            self.noteLabel.textColor = newState.lineTextColor
            self.noteLabel.font = newState.font
            self.centsLabel.textColor = newState.lineTextColor
            self.centsLabel.font = newState.centsLabelFont
            self.octaveLabel.textColor = newState.lineTextColor
            self.octaveLabel.font = newState.octaveLabelFont
            self.displayPitch(pitch: self.noteLabel.text!)
        }, completion: { _ in })
        
        UIView.transition(with: self.settingsButton, duration: 0.2, options: options, animations: {
            self.settingsButton.setImage(newState.menuImage, for: .normal)
        }, completion: { _ in })
        
        UIView.transition(with: self.pitchPipeButton, duration: 0.2, options: options, animations: {
            let image = self.isPitchPipeOpen ? newState.downArrowImage : newState.audioWaveImage
            self.pitchPipeButton.setImage(image, for: .normal)
        }, completion: { _ in })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
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
    
    func updateCentsLabel(offset: Double) {
        centsLabel.text = offset > 0 ? "+\(offset.roundTo(places: 1))" : "\(offset.roundTo(places: 1))"
    }
}
