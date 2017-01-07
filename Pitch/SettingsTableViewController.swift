//
//  SettingsTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/7/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

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
    
    var delegate: SettingsTableViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var micSensitivityLabel: UILabel!
    @IBOutlet weak var displayModeControl: UISegmentedControl!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet var allLabels: [UILabel]!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        displayModeControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Lato-Semibold", size: 19.0)!], for: .normal)
        tableView.tableFooterView = UIView()
        micSensitivityLabel.text = currentMicSensitivity.name
        displayModeControl.selectedSegmentIndex = currentDisplayMode == .sharps ? 0 : 1
        darkModeSwitch.setOn(darkModeOn, animated: false)
        updateKeyLabel()
        darkModeChanged()
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
    
    func darkModeChanged() {
        view.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.white
        tableView.separatorColor = darkModeOn ? UIColor.darkPitchPipeBackground : UIColor.separatorColor
        displayModeControl.tintColor = darkModeOn ? UIColor.white : UIColor.black
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
}
