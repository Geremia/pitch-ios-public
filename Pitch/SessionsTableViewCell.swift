//
//  SessionsTableViewCell.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/3/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

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
    
    var isExpanded: Bool = false {
        didSet {
            heightConstraint.constant = isExpanded ? 160 : 70
        }
    }
    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Selected State

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
