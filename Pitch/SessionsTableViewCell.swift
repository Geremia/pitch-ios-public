//
//  SessionsTableViewCell.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/3/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

protocol SessionsTableViewCellDelegate {
    func sharePressedOn(_ cell: SessionsTableViewCell)
    func analyticsPressedOn(_ cell: SessionsTableViewCell)
    func deletePressedOn(_ cell: SessionsTableViewCell)
    func nameEditedOn(_ cell: SessionsTableViewCell)
}

class SessionsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timePassedLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var analyticsButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var delegate: SessionsTableViewCellDelegate?
    
    var isExpanded: Bool = false {
        didSet {
            heightConstraint.constant = isExpanded ? 160 : 70
            nameField.isUserInteractionEnabled = isExpanded
            nameField.resignFirstResponder()
        }
    }
    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        
        slider.setThumbImage(#imageLiteral(resourceName: "slider_thumb"), for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func playPausePressed(_ sender: Any) {
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        delegate?.sharePressedOn(self)
    }
    
    @IBAction func analyticsPressed(_ sender: Any) {
        delegate?.analyticsPressedOn(self)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate?.deletePressedOn(self)
    }
    
    // MARK: - Selected State

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SessionsTableViewCell: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.nameEditedOn(self)
    }
}
