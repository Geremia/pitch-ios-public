//
//  SettingsTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/7/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

protocol SettingsTableViewControllerDelegate {
    func instrumentKeySelected()
}

class SettingsTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    var currentMicSensitivity: MicSensitivity = UserDefaults.standard.micSensitivity() {
        didSet {
            UserDefaults.standard.setMicSensitivity(currentMicSensitivity)
        }
    }
    var currentDisplayMode: DisplayMode = UserDefaults.standard.displayMode() {
        didSet {
            UserDefaults.standard.setDisplayMode(currentDisplayMode)
        }
    }
    var darkModeOn: Bool = UserDefaults.standard.darkModeOn() {
        didSet {
            UserDefaults.standard.setDarkModeOn(darkModeOn)
            darkModeChanged()
            NotificationCenter.default.post(name: .darkModeChanged, object: nil)
        }
    }
    var currentPitchStandard: Double = UserDefaults.standard.pitchStandard() {
        didSet {
            UserDefaults.standard.setPitchStandard(currentPitchStandard)
        }
    }
    
    var delegate: SettingsTableViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var displayModeControl: TwicketSegmentedControl!
    @IBOutlet weak var micSensitivityLabel: UILabel!
    
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultyDescriptionLabel: UILabel!
    
    @IBOutlet weak var dampingLabel: UILabel!
    @IBOutlet weak var dampingDescriptionLabel: UILabel!
    
    @IBOutlet weak var keyLabel: UILabel!
    
    @IBOutlet weak var pitchStandardLabel: UILabel!
    @IBOutlet weak var minusPitchStandardButton: UIButton!
    @IBOutlet weak var plusPitchStandardButton: UIButton!
    
    @IBOutlet var allLabels: [UILabel]!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDisplayModeControl()
        
        tableView.tableFooterView = UIView()
        micSensitivityLabel.text = currentMicSensitivity.name
        darkModeSwitch.setOn(darkModeOn, animated: false)
        
        updatePitchStandardLabel()
        updateKeyLabel()
        darkModeChanged()
    }
    
    func setupDisplayModeControl() {
        displayModeControl.setSegmentItems(["♯", "♭"])
        style(twicketSegmetedControl: displayModeControl)
        displayModeControl.move(to: currentDisplayMode == .sharps ? 0 : 1)
        displayModeControl.delegate = self
    }
    
    func style(twicketSegmetedControl control: TwicketSegmentedControl) {
        control.segmentsBackgroundColor = darkModeOn ? UIColor.darkPitchPipeBackground : UIColor.separatorColor
        control.sliderBackgroundColor = darkModeOn ? UIColor.darkInTune : UIColor.inTune
        control.font = UIFont(name: "Lato-Semibold", size: 19.0)!
        control.isSliderShadowHidden = true
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            changeMicSensitivity()
        case 2:
            delegate?.instrumentKeySelected()
        default:
            return
        }
    }
    
    // MARK: - Change Settings
    
    func changeMicSensitivity() {
        var rawValue = currentMicSensitivity.rawValue + 1
        if rawValue > 2 {
            rawValue = 0
        }
        
        currentMicSensitivity = MicSensitivity(rawValue: rawValue)!
        UIView.transition(with: micSensitivityLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.micSensitivityLabel.text = self.currentMicSensitivity.name
        }, completion: nil)
    }
    
    func updateKeyLabel() {
        let currentKey = UserDefaults.standard.key()
        let currentInstrument = UserDefaults.standard.instrument()
        if currentKey.description.characters.count > 1 {
            let font = keyLabel.font
            let fontSuper:UIFont? = keyLabel.font.withSize(14.0)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: "\(currentInstrument.description) (\(currentKey.description))", attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 6], range: NSRange(location: attString.length - 2, length: 1))
            if currentInstrument == .bFlatClarinet || currentInstrument == .eFlatClarinet {
                attString.addAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 6], range: NSRange(location: 1, length: 1))
            }
            keyLabel.attributedText = attString
        } else {
            keyLabel.attributedText = NSMutableAttributedString(string: "\(currentInstrument.description) (\(currentKey.description))", attributes: nil)
        }
    }
    
    func updatePitchStandardLabel() {
        pitchStandardLabel.text = "A\(Int(currentPitchStandard))"
    }
    
    func darkModeChanged() {
        view.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.white
        tableView.separatorColor = darkModeOn ? UIColor.darkPitchPipeBackground : UIColor.separatorColor
        style(twicketSegmetedControl: displayModeControl)
        
        plusPitchStandardButton.setImage(darkModeOn ? #imageLiteral(resourceName: "white_small_plus") : #imageLiteral(resourceName: "small_plus"), for: .normal)
        minusPitchStandardButton.setImage(darkModeOn ? #imageLiteral(resourceName: "white_small_minus") : #imageLiteral(resourceName: "small_minus"), for: .normal)
        
        for label in allLabels {
            label.textColor = darkModeOn ? UIColor.white : UIColor.black
        }
    }
    
    // MARK: - Actions

    @IBAction func darkModeSwitched(_ sender: Any) {
        darkModeOn = (sender as! UISwitch).isOn
    }
    
    @IBAction func displayModeSelected(_ sender: Any) {
        let selectedSegment = (sender as! UISegmentedControl).selectedSegmentIndex
        currentDisplayMode = selectedSegment == 0 ? .sharps : .flats
        updateKeyLabel()
    }
    
    @IBAction func pitchStandardDecrement(_ sender: Any) {
        currentPitchStandard -= 1
        updatePitchStandardLabel()
    }
    
    @IBAction func pitchStandardIncrement(_ sender: Any) {
        currentPitchStandard += 1
        updatePitchStandardLabel()
    }
}

extension SettingsTableViewController : TwicketSegmentedControlDelegate {
    
    func twicketSegmentedControl(_ segmentedControl: TwicketSegmentedControl, didSelect segmentIndex: Int) {
        currentDisplayMode = segmentIndex == 0 ? .sharps : .flats
        updateKeyLabel()
    }
    
}
