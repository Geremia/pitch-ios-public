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
        animateIn()
    }
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        updateDarkMode()
        setupDescriptionLabel()
        
        scoreLabel.format = "%d"
        
        scoreCircle.transform = CGAffineTransform(scaleX: 0, y: 0)
        scoreCircle.alpha = 0.0
        todayLabel.alpha = 0.0
        todaySeparator.alpha = 0.0
        descriptionLabel.alpha = 0.0
        
        todayLabelTopConstraint.constant += 250
        todaySeparatorTopConstraint.constant += 350
        descriptionLabelTopConstraint.constant += 450
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
    
    func animateIn() {
        let score = UserDefaults.standard.today().inTunePercentage.roundTo(places: 2) * 100
        self.scoreLabel.countFromZero(to: CGFloat(score), withDuration: 1.2)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.01, options: [.curveEaseInOut], animations: {
            self.scoreCircle.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.scoreCircle.alpha = 1.0
        }, completion: nil)
        
        todayLabelTopConstraint.constant -= 250
        todaySeparatorTopConstraint.constant -= 350
        descriptionLabelTopConstraint.constant -= 450
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 1.2, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
            self.todayLabel.alpha = 1.0
            self.todaySeparator.alpha = 1.0
            self.descriptionLabel.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - Dark Mode Switching
    
    func updateDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
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
