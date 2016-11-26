//
//  InstrumentKeyTableViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 11/25/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit

class InstrumentKeyTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Variables
    
    @IBOutlet weak var autoKeyLabel: UILabel!
    @IBOutlet weak var autoKeySwitch: UISwitch!
    
    // MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isScrollEnabled = false
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(InstrumentKeyTableViewController.darkModeChanged), name: darkModeChangedNotification, object: nil)
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            autoKeyLabel.textColor = UIColor.white
            autoKeySwitch.onTintColor = UIColor.darkInTune
        } else {
            autoKeyLabel.textColor = UIColor.black
            autoKeySwitch.onTintColor = UIColor.inTune
        }
        
        pickerView.reloadAllComponents()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // MARK: - UIPickerViewDelegate
    
    let instruments = ["Bb Clarinet", "Eb Clarinet", "Alto Saxophone", "Piano", "Trumpet"]
    let keys = ["C", "D♭","D","E♭","E","F","G♭","G","A♭","A","B♭","B"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return instruments[row]
        default:
            return keys[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let string: NSMutableAttributedString
        switch component {
        case 0:
            string = NSMutableAttributedString(string: instruments[row])
        default:
            string = NSMutableAttributedString(string: keys[row])
        }
        
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            string.addAttributes([NSFontAttributeName:UIFont(name: "Lato-Light", size: 22.0)!,NSForegroundColorAttributeName:UIColor.white], range: NSMakeRange(0, string.length))
        } else {
            string.addAttributes([NSFontAttributeName:UIFont(name: "Lato-Light", size: 22.0)!,NSForegroundColorAttributeName:UIColor.black], range: NSMakeRange(0, string.length))
        }
        
        let label = UILabel()
        label.attributedText = string
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return view.frame.width * 0.6
        default:
            return view.frame.width * 0.4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected row")
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return instruments.count
        default:
            return keys.count
        }
    }
    
    // MARK: - Actions
    
    @IBAction func autoKeySwitched(_ sender: Any) {
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
