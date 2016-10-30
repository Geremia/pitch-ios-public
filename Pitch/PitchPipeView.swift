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
//    var soundGenerator: SoundGenerator = SoundGenerator()
    
    // MARK: - Awake from Nib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let oscillator = AKOscillator()
//        oscillator.waveform = AKTable(size: 4096)
//        oscillator.frequency = AKParameter(value: 440.0)
//        oscillator.amplitude = AKParameter(value: 1.0)
//        AKOrchestra.start()
//        oscillator.
        
//        soundGenerator.setUp()
    }
    
    // MARK: - Pitch Button UI
    
    func on(pitchButton button: UIButton) {
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            button.backgroundColor = UIColor.greenView
            button.titleLabel?.font = UIFont(name: "Lato-Semibold", size: 26)
            button.setTitleColor(UIColor.white, for: .normal)
            }, completion: nil)
    }
    
    func off(pitchButton button: UIButton) {
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            button.backgroundColor = UIColor.white
            button.titleLabel?.font = UIFont(name: "Lato-Light", size: 26)
            button.setTitleColor(UIColor.grayText, for: .normal)
            }, completion: nil)
    }
    
    // MARK: - Actions

    @IBAction func pitchButtonPressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        let isActive = button.backgroundColor == UIColor.greenView
        if isActive {
            off(pitchButton: button)
//            soundGenerator.playNoteOff(channelNumber: button.tag)
        } else {
            on(pitchButton: button)
//            soundGenerator.playNoteOn(channelNumber: button.tag)
        }
    }
    
    @IBAction func pitchButtonReleased(_ sender: AnyObject) {
        if !sustainOn {
            let button = sender as! UIButton
            off(pitchButton: button)
//            soundGenerator.playNoteOff(channelNumber: button.tag)
        }
    }
    
    @IBAction func sustainButtonPressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        let image = sustainOn ? #imageLiteral(resourceName: "infinity") : #imageLiteral(resourceName: "white_infinity")
        let color = sustainOn ? UIColor.white : UIColor.greenView
        UIView.transition(with: button, duration: 0.05, options: .transitionCrossDissolve, animations: {
            button.setImage(image, for: .normal)
            button.backgroundColor = color
            }, completion: nil)
        for button in self.pitchButtons {
            off(pitchButton: button)
//            soundGenerator.playNoteOff(channelNumber: button.tag)
        }
        sustainOn = !sustainOn
    }
    
    @IBAction func minusButtonPressed(_ sender: AnyObject) {
        var currentOctave = Int(octaveLabel.text!)!
        if currentOctave > 3 {
            currentOctave -= 1
        }
        octaveLabel.text = String(currentOctave)
    }
    
    @IBAction func plusButtonPressed(_ sender: AnyObject) {
        var currentOctave = Int(octaveLabel.text!)!
        if currentOctave < 7 {
            currentOctave += 1
        }
        octaveLabel.text = String(currentOctave)
    }
}
