//
//  SessionsTableViewCell.swift
//  Pitch
//
//  Created by Daniel Kuntz on 3/3/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit

protocol SessionsTableViewCellDelegate {
    func sharePressedAt(_ indexPath: IndexPath)
    func analyticsPressedAt(_ indexPath: IndexPath)
    func deletePressedAt(_ indexPath: IndexPath)
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
    
    var delegate: SessionsTableViewCellDelegate
    var indexPath: IndexPath?
    
    var isExpanded: Bool = false {
        didSet {
            heightConstraint.constant = isExpanded ? 160 : 70
            nameField.isUserInteractionEnabled = isExpanded
        }
    }
    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Actions
    
    @IBAction func playPausePressed(_ sender: Any) {
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        delegate.sharePressedAt(indexPath)
    }
    
    @IBAction func analyticsPressed(_ sender: Any) {
        delegate.analyticsPressedAt(indexPath)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        delegate.deletePressedAt(indexPath)
    }
    
    // MARK: - Selected State

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
