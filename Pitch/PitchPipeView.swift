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
    @IBOutlet var sustainButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var octaveLabel: UILabel!
    
    // MARK: - Properties
    
    var sustainOn: Bool = false
    var soundGenerator: SoundGenerator = SoundGenerator()
    
    // MARK: - Awake From Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PitchPipeView.allOff), name: pitchPipeResetNotification, object: nil)
    }
    
    // MARK: - Pitch Button UI
    
    func on(pitchButton button: UIButton) {
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            button.backgroundColor = UIColor.greenView
            button.setAttributedTitle(nil, for: .normal)
            button.titleLabel?.font = UIFont(name: "Lato-Semibold", size: 26)
            button.setTitleColor(UIColor.white, for: .normal)
            self.updateButtonLabels()
            }, completion: nil)
    }
    
    func off(pitchButton button: UIButton) {
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            button.backgroundColor = UIColor.clear
            button.setAttributedTitle(nil, for: .normal)
            button.titleLabel?.font = UIFont(name: "Lato-Light", size: 26)
            button.setTitleColor(UIColor.grayText, for: .normal)
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
                    attString.setAttributes([NSFontAttributeName:fontSuper!, NSBaselineOffsetAttributeName:12], range: NSRange(location:1,length:1))
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
        let isActive = button.backgroundColor == UIColor.greenView
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
        let button = sender as! UIButton
        let image = sustainOn ? #imageLiteral(resourceName: "infinity") : #imageLiteral(resourceName: "white_infinity")
        let color = sustainOn ? UIColor.clear : UIColor.greenView
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            button.setImage(image, for: .normal)
            button.backgroundColor = color
            }, completion: nil)
        allOff()
        sustainOn = !sustainOn
    }
    
    func allOff() {
        for button in self.pitchButtons {
            off(pitchButton: button)
            soundGenerator.playNoteOff(channelNumber: button.tag)
        }
    }
    
    @IBAction func minusButtonPressed(_ sender: AnyObject) {
        var currentOctave = Int(octaveLabel.text!)!
        if currentOctave > 1 {
            currentOctave -= 1
            soundGenerator.decrementOctave()
            octaveLabel.text = String(currentOctave)
        }
    }
    
    @IBAction func plusButtonPressed(_ sender: AnyObject) {
        var currentOctave = Int(octaveLabel.text!)!
        if currentOctave < 5 {
            currentOctave += 1
            soundGenerator.incrementOctave()
            octaveLabel.text = String(currentOctave)
        }
    }
}
