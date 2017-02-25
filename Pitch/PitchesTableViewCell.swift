//
//  PitchesTableViewCell.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/6/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

class PitchesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var pitchLabel: UILabel!
    @IBOutlet weak var centsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
    }
    
    // MARK: - Dark Mode Switching
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        numberLabel.textColor = darkModeOn ? UIColor.white : UIColor.black
        pitchLabel.textColor = darkModeOn ? UIColor.white : UIColor.black
    }
    
    // MARK: - Update Cents Label

    func updateCentsLabel(cents: Double) {
        let centsString = cents <= 0 ? "\(cents)" : "+\(cents)"
        centsLabel.text = centsString + " cents (average)"
        centsLabel.textColor = cents < 0 ? UIColor.textLighterRed : UIColor.lighterPurple
    }
    
}
