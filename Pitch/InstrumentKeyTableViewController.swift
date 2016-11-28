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
    
    var autoKeyOn: Bool = UserDefaults.standard.autoKeyOn() {
        didSet {
            UserDefaults.standard.setAutoKey(autoKeyOn)
        }
    }
    var currentInstrument: Instrument = UserDefaults.standard.instrument() {
        didSet {
            UserDefaults.standard.setInstrument(currentInstrument)
        }
    }
    
    let instruments: [Instrument] = Instrument.allCases
    let keys: [Key] = Key.allCases
    
    // MARK: - Outlets
    
    @IBOutlet weak var autoKeyLabel: UILabel!
    @IBOutlet weak var autoKeySwitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        tableView.isScrollEnabled = false
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(InstrumentKeyTableViewController.darkModeChanged), name: darkModeChangedNotification, object: nil)
    }
    
    // MARK: - Setup Picker View
    
    func setupPickerView() {
        autoKeySwitch.setOn(autoKeyOn, animated: false)
        if let index = instruments.index(of: currentInstrument) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
            if autoKeyOn {
                setKeyForCurrentInstrument(animated: false)
            } else {
                let currentKey = UserDefaults.standard.key()
                pickerView.selectRow(keys.index(of: currentKey)!, inComponent: 1, animated: false)
            }
        }
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        autoKeyLabel.textColor = darkModeOn ? UIColor.white : UIColor.black
        autoKeySwitch.onTintColor = darkModeOn ? UIColor.darkInTune : UIColor.inTune
        tableView.separatorColor = darkModeOn ? UIColor.darkGray : UIColor.separatorColor
        
        pickerView.reloadAllComponents()
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return instruments[row].name
        default:
            return keys[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let string: NSMutableAttributedString
        switch component {
        case 0:
            string = NSMutableAttributedString(string: instruments[row].name)
        default:
            string = NSMutableAttributedString(string: "\(keys[row].name) (\(keys[row].concertOffsetString))")
        }
        
        let darkModeOn = UserDefaults.standard.darkModeOn()
        let color = darkModeOn ? UIColor.white : UIColor.black
        string.addAttributes([NSFontAttributeName:UIFont(name: "Lato-Light", size: 22.0)!,NSForegroundColorAttributeName:color], range: NSMakeRange(0, string.length))
        
        let label = UILabel()
        label.attributedText = string
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.frame.width * 0.5
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            currentInstrument = instruments[row]
            if autoKeyOn {
                setKeyForCurrentInstrument(animated: true)
            }
        default:
            autoKeySwitch.setOn(false, animated: true)
            UserDefaults.standard.setAutoKey(false)
            UserDefaults.standard.setKey(newValue: keys[row])
        }
    }
    
    func setKeyForCurrentInstrument(animated: Bool) {
        guard let index = self.keys.index(of: currentInstrument.key) else { return }
        pickerView.selectRow(index, inComponent: 1, animated: animated)
        UserDefaults.standard.setKey(newValue: self.keys[index])
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
        let keySwitch = sender as! UISwitch
        autoKeyOn = keySwitch.isOn
        if keySwitch.isOn {
            setKeyForCurrentInstrument(animated: true)
        }
    }
}
