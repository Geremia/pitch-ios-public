//
//  SettingsTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/7/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

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
    var currentKey: Key = UserDefaults.standard.key() {
        didSet {
            UserDefaults.standard.setKey(newValue: currentKey)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var micSensitivityLabel: UILabel!
    @IBOutlet weak var displayModeLabel: UILabel!
    @IBOutlet weak var keyLabel: UILabel!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        micSensitivityLabel.text = currentMicSensitivity.name
        displayModeLabel.text = currentDisplayMode.name
        keyLabel.text = currentKey.name
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            changeMicSensitivity()
        case 1:
            changeDisplayMode()
        case 2:
            changeKey()
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
            self.keyLabel.text = self.currentKey.name
        }, completion: nil)
    }
    
    func changeKey() {
        var rawValue = currentKey.rawValue + 1
        if rawValue > 11 {
            rawValue = 0
        }
        
        currentKey = Key(rawValue: rawValue)!
        UIView.transition(with: keyLabel, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.keyLabel.text = self.currentKey.name
        }, completion: nil)
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
