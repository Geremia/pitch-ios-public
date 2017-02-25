//
//  Onboarding4ViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 2/25/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class Onboarding4ViewController: OnboardingViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Variables
    
    let instruments: [Instrument] = Instrument.all
    var currentInstrument: Instrument = .other
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return instruments[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let string: NSMutableAttributedString = NSMutableAttributedString(string: instruments[row].description)
        string.addAttributes([NSFontAttributeName:UIFont(name: "Lato-Light", size: 22.0)!], range: NSMakeRange(0, string.length))
        
        let label = UILabel()
        label.attributedText = string
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentInstrument = instruments[row]
    }
    
    // MARK: - Actions
    
    @IBAction func nextPressed(_ sender: Any) {
        UserDefaults.standard.setInstrument(currentInstrument)
    }
    
    @IBAction func skipPressed(_ sender: Any) {
        performSegue(withIdentifier: "onboarding45", sender: nil)
    }
    
}
