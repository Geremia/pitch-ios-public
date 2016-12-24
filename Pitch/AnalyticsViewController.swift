//
//  AnalyticsViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 12/24/16.
//  Copyright © 2016 Plutonium Apps. All rights reserved.
//

import UIKit
import UICountingLabel

class AnalyticsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var analyticsLabel: UILabel!
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataImageView: UIImageView!
    
    @IBOutlet weak var scoreCircle: UIView!
    @IBOutlet weak var scoreLabel: UICountingLabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var todaySeparator: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var todayLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var todaySeparatorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        if !defaults.hasSeenAnalyticsAnimation() && defaults.today().hasSufficientData {
            animateIn()
            UserDefaults.standard.setHasSeenAnalyticsAnimation(true)
        }
    }
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        updateDarkMode()
        
        let today = UserDefaults.standard.today()
        if today.hasSufficientData {
            noDataView.isHidden = true
            
            let score = today.inTunePercentage.roundTo(places: 2) * 100
            scoreLabel.text = "\(Int(score))"
            setupDescriptionLabel()
            
            if !UserDefaults.standard.hasSeenAnalyticsAnimation() {
                prepareForAnimation()
            }
        }
    }
    
    func setupDescriptionLabel() {
        let boldFont = UIFont(name: "Lato-Regular", size: 17.0)!
        let lightFont = UIFont(name: "Lato-Light", size: 17.0)!
        let percentage = UserDefaults.standard.today().inTunePercentage.roundTo(places: 2) * 100
        let time = UserDefaults.standard.today().timeToCenter.roundTo(places: 1)
        
        let percentageString: NSAttributedString = NSAttributedString(string: "\(Int(percentage))%", attributes: [NSFontAttributeName: boldFont])
        let timeString: NSAttributedString = NSAttributedString(string: "\(time) seconds", attributes: [NSFontAttributeName: boldFont])
        
        let descriptionString: NSMutableAttributedString = NSMutableAttributedString(string: "You were in tune ", attributes: [NSFontAttributeName: lightFont])
        descriptionString.append(percentageString)
        descriptionString.append(NSAttributedString(string: " of the time, and you took ", attributes: [NSFontAttributeName: lightFont]))
        descriptionString.append(timeString)
        descriptionString.append(NSAttributedString(string: " on average to center the pitch.", attributes: [NSFontAttributeName: lightFont]))
        
        descriptionLabel.attributedText = descriptionString
    }
    
    // MARK: - Dark Mode Switching
    
    func updateDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            noDataView.backgroundColor = .darkGrayView
            noDataImageView.image = #imageLiteral(resourceName: "line_chart_darkgray")
            noDataLabel.textColor = .darkGray
            
            view.backgroundColor = .darkGrayView
            backButton.setImage(#imageLiteral(resourceName: "white_back_arrow"), for: .normal)
            analyticsLabel.textColor = .white
            todayLabel.textColor = .white
            todaySeparator.backgroundColor = .white
            descriptionLabel.textColor = .white
        }
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
