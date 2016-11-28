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
            UserDefaults.standard.setMicSensitivity(newValue: currentMicSensitivity)
        }
    }
    var currentDisplayMode: DisplayMode = UserDefaults.standard.displayMode() {
        didSet {
            UserDefaults.standard.setDisplayMode(newValue: currentDisplayMode)
        }
    }
    var darkModeOn: Bool = UserDefaults.standard.darkModeOn() {
        didSet {
            UserDefaults.standard.setDarkModeOn(darkModeOn)
            darkModeChanged()
            NotificationCenter.default.post(name: darkModeChangedNotification, object: nil)
        }
    }
    
    var delegate: SettingsTableViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var micSensitivityLabel: UILabel!
    @IBOutlet weak var displayModeLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    @IBOutlet var allLabels: [UILabel]!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        micSensitivityLabel.text = currentMicSensitivity.name
        displayModeLabel.text = currentDisplayMode.name
        darkModeSwitch.setOn(darkModeOn, animated: false)
        updateKeyLabel()
        darkModeChanged()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            changeMicSensitivity()
        case 1:
            changeDisplayMode()
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
    
    func changeDisplayMode() {
        var rawValue = currentDisplayMode.rawValue + 1
        if rawValue > 1 {
            rawValue = 0
        }
        
        currentDisplayMode = DisplayMode(rawValue: rawValue)!
        UIView.transition(with: displayModeLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.displayModeLabel.text = self.currentDisplayMode.name
            self.updateKeyLabel()
        }, completion: nil)
    }
    
    func updateKeyLabel() {
        let currentKey = UserDefaults.standard.key()
        if currentKey.name.characters.count > 1 {
            let font = keyLabel.font
            let fontSuper:UIFont? = keyLabel.font.withSize(14.0)
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: currentKey.name, attributes: [NSFontAttributeName:font!])
            attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 6], range: NSRange(location: 1, length: 1))
            keyLabel.attributedText = attString
        } else {
            keyLabel.attributedText = NSMutableAttributedString(string: currentKey.name, attributes: nil)
        }
    }

    @IBAction func darkModeSwitched(_ sender: Any) {
        darkModeOn = (sender as! UISwitch).isOn
    }
    
    func darkModeChanged() {
        view.backgroundColor = darkModeOn ? UIColor.darkGrayView : UIColor.white
        tableView.separatorColor = darkModeOn ? UIColor.darkGray : UIColor.separatorColor
        for label in allLabels {
            label.textColor = darkModeOn ? UIColor.white : UIColor.black
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
