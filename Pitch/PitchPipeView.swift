//
//  PitchPipeView.swift
//  Pitch
//
//  Created by Daniel Kuntz on 10/29/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import AudioKit

class PitchPipeView: UIView {

    // MARK: - Outlets
    
    @IBOutlet var pitchButtons: [UIButton]!
    @IBOutlet var separators: [UIView]!
    @IBOutlet var sustainButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var octaveLabel: UILabel!
    @IBOutlet var octaveTextLabel: UILabel!
    
    // MARK: - Properties
    
    var sustainOn: Bool = false
    var soundGenerator: SoundGenerator = SoundGenerator()
    
    // MARK: - Awake From Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        darkModeChanged()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PitchPipeView.allOff), name: pitchPipeResetNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PitchPipeView.darkModeChanged), name: darkModeChangedNotification, object: nil)
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            backgroundColor = UIColor.darkPitchPipeBackground
            minusButton.setImage(#imageLiteral(resourceName: "white_minus"), for: .normal)
            plusButton.setImage(#imageLiteral(resourceName: "white_plus"), for: .normal)
            octaveLabel.textColor = UIColor.white
            octaveTextLabel.textColor = UIColor.white
        } else {
            backgroundColor = UIColor.white
            minusButton.setImage(#imageLiteral(resourceName: "minus"), for: .normal)
            plusButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
            octaveLabel.textColor = UIColor.grayText
            octaveTextLabel.textColor = UIColor.grayText
        }
        
        updateSustainButton()
        for button in self.pitchButtons {
            let isActive = button.backgroundColor == UIColor.inTune || button.backgroundColor == UIColor.darkInTune
            isActive ? on(pitchButton: button) : off(pitchButton: button)
        }
        
        for separator in separators {
            separator.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.separatorColor
        }
    }
    
    // MARK: - Pitch Button UI
    
    func on(pitchButton button: UIButton) {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            if darkModeOn {
                button.backgroundColor = UIColor.darkInTune
            } else {
                button.backgroundColor = UIColor.inTune
            }
            button.setAttributedTitle(nil, for: .normal)
            button.titleLabel?.font = UIFont(name: "Lato-Semibold", size: 24)
            button.setTitleColor(UIColor.white, for: .normal)
            self.updateButtonLabels()
        }, completion: nil)
    }
    
    func off(pitchButton button: UIButton) {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            if darkModeOn {
                button.setTitleColor(UIColor.white, for: .normal)
            } else {
                button.setTitleColor(UIColor.grayText, for: .normal)
            }
            button.backgroundColor = UIColor.clear
            button.setAttributedTitle(nil, for: .normal)
            button.titleLabel?.font = UIFont(name: "Lato-Light", size: 24)
            self.updateButtonLabels()
        }, completion: nil)
    }
    
    func updateButtonLabels() {
        for button in self.pitchButtons {
            if let key = Key.fromName((button.titleLabel?.text)!) {
                if key.name.characters.count > 1 {
                    let font = button.titleLabel?.font
                    let fontSuper:UIFont? = button.titleLabel?.font.withSize(18.0)
                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: key.name, attributes: [NSFontAttributeName:font!])
                    attString.setAttributes([NSFontAttributeName:fontSuper!, NSBaselineOffsetAttributeName:11], range: NSRange(location:1,length:1))
                    button.setAttributedTitle(attString, for: .normal)
                } else {
                    button.setTitle(key.name, for: .normal)
                }
            }
        }
    }
    
    // MARK: - Actions

    @IBAction func pitchButtonPressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        let isActive = button.backgroundColor == UIColor.inTune || button.backgroundColor == UIColor.darkInTune
        if isActive {
            off(pitchButton: button)
            soundGenerator.playNoteOff(channelNumber: button.tag)
        } else {
            on(pitchButton: button)
            soundGenerator.playNoteOn(channelNumber: button.tag)
        }
    }
    
    @IBAction func pitchButtonReleased(_ sender: AnyObject) {
        if !sustainOn {
            let button = sender as! UIButton
            off(pitchButton: button)
            soundGenerator.playNoteOff(channelNumber: button.tag)
        }
    }
    
    @IBAction func sustainButtonPressed(_ sender: AnyObject) {
        sustainOn = !sustainOn
        updateSustainButton()
        allOff()
    }
    
    func updateSustainButton() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        let image: UIImage
        let color: UIColor
        if darkModeOn {
            image = sustainOn ? #imageLiteral(resourceName: "thick_infinity") : #imageLiteral(resourceName: "white_infinity")
            color = sustainOn ? UIColor.darkInTune : UIColor.clear
        } else {
            image = sustainOn ? #imageLiteral(resourceName: "thick_infinity") : #imageLiteral(resourceName: "infinity")
            color = sustainOn ? UIColor.inTune : UIColor.clear
        }
        
        UIView.transition(with: sustainButton, duration: 0.05, options: .transitionCrossDissolve, animations: {
            self.sustainButton.setImage(image, for: .normal)
            self.sustainButton.backgroundColor = color
        }, completion: nil)
    }
    
    func allOff() {
        for button in self.pitchButtons {
            off(pitchButton: button)
            soundGenerator.playNoteOff(channelNumber: button.tag)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: AnyObject) {
        var currentOctave = Int(octaveLabel.text!)!
        if currentOctave > 3 {
            currentOctave -= 1
            soundGenerator.decrementOctave()
            octaveLabel.text = String(currentOctave)
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: AnyObject) {
        var currentOctave = Int(octaveLabel.text!)!
        if currentOctave < 7 {
            currentOctave += 1
            soundGenerator.incrementOctave()
            octaveLabel.text = String(currentOctave)
        }
    }
}
