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
    var isPlaying: Bool = false
    
    var isExpanded: Bool = false {
        didSet {
            heightConstraint.constant = isExpanded ? 160 : 70
            nameField.isUserInteractionEnabled = isExpanded
            nameField.resignFirstResponder()
            
            if isExpanded == false && nameField.text == "" {
                nameField.text = "Untitled"
                delegate?.nameEditedOn(self)
            }
        }
    }
    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        slider.setThumbImage(#imageLiteral(resourceName: "slider_thumb"), for: .normal)
        
        darkModeChanged()
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeChanged), name: .darkModeChanged, object: nil)
    }
    
    // MARK: - Dark Mode
    
    func darkModeChanged() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        
        let textColor = darkModeOn ? UIColor.white : UIColor.black
        nameField.textColor = textColor
        dateLabel.textColor = textColor
        durationLabel.textColor = textColor
        
        let mutedTextColor = darkModeOn ? UIColor.lightGray : UIColor.darkGray
        timePassedLabel.textColor = mutedTextColor
        timeLeftLabel.textColor = mutedTextColor
        
        resetPlayPauseImage()
        
        let minTrackColor = darkModeOn ? UIColor.darkGray : UIColor.lightGray
        let maxTrackColor = darkModeOn ? UIColor.darkSeparatorColor : UIColor.separatorColor
        let sliderThumb = darkModeOn ? #imageLiteral(resourceName: "dark_slider_thumb") : #imageLiteral(resourceName: "slider_thumb")
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.setThumbImage(sliderThumb, for: .normal)
        
        let shareImage = darkModeOn ? #imageLiteral(resourceName: "white_share") : #imageLiteral(resourceName: "share")
        let analyticsImage = darkModeOn ? #imageLiteral(resourceName: "white_analytics") : #imageLiteral(resourceName: "analytics")
        let deleteImage = darkModeOn ? #imageLiteral(resourceName: "white_trash") /* hehe */ : #imageLiteral(resourceName: "trash")
        shareButton.setImage(shareImage, for: .normal)
        analyticsButton.setImage(analyticsImage, for: .normal)
        deleteButton.setImage(deleteImage, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func playPausePressed(_ sender: Any) {
        isPlaying = !isPlaying
        resetPlayPauseImage()
    }
    
    func resetPlayPauseImage() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        let image: UIImage
        if darkModeOn {
            image = isPlaying ? #imageLiteral(resourceName: "white_pause") : #imageLiteral(resourceName: "white_play")
        } else {
            image = isPlaying ? #imageLiteral(resourceName: "pause") : #imageLiteral(resourceName: "play")
        }
        playPauseButton.setImage(image, for: .normal)
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
