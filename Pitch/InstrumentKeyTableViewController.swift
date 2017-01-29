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
    
    let instruments: [Instrument] = Instrument.all
    let keys: [Key] = [.fsharp, .g, .gsharp, .a, .asharp, .b, .c, .csharp, .d, .dsharp, .e, .f]
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(InstrumentKeyTableViewController.darkModeChanged), name: .darkModeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openAnalytics), name: NSNotification.Name(rawValue: ShortcutIdentifier.Analytics.rawValue), object: nil)
    }
    
    // MARK: - Notifications
    
    func openAnalytics() {
        dismiss(animated: false, completion: {
            // Post the notification again so SettingsViewController can dismiss
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ShortcutIdentifier.Analytics.rawValue), object: nil)
        })
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
        
        if pickerView.subviews.count > 2 {
            pickerView.subviews[1].isHidden = true
            pickerView.subviews[2].isHidden = true
        }
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        autoKeyLabel.textColor = darkModeOn ? UIColor.white : UIColor.black
        autoKeySwitch.onTintColor = darkModeOn ? UIColor.darkInTune : UIColor.inTune
        tableView.separatorColor = darkModeOn ? UIColor.darkPitchPipeBackground : UIColor.separatorColor
        
        pickerView.reloadAllComponents()
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return instruments[row].description
        default:
            return keys[row].description
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let string: NSMutableAttributedString
        switch component {
        case 0:
            string = NSMutableAttributedString(string: instruments[row].description)
        default:
            string = NSMutableAttributedString(string: "\(keys[row].description) (\(keys[row].concertOffsetString))")
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
            autoKeyOn = false
            UserDefaults.standard.setKey(keys[row])
        }
    }
    
    func setKeyForCurrentInstrument(animated: Bool) {
        guard let index = self.keys.index(of: currentInstrument.key) else { return }
        pickerView.selectRow(index, inComponent: 1, animated: animated)
        UserDefaults.standard.setKey(self.keys[index])
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
