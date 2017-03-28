//
//  ShareViewController.swift
//  Pitch
//
//  Created by Daniel Kuntz on 1/16/17.
//  Copyright © 2017 Plutonium Apps. All rights reserved.
//

import UIKit
import MessageUI
import Crashlytics

protocol ShareViewControllerDelegate {
    func userDidShare()
}

class ShareViewController: StyledViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Properties
    
    var delegate: ShareViewControllerDelegate?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        updateForDarkMode()
    }
    
    func updateForDarkMode() {
        let darkModeOn = UserDefaults.standard.darkModeOn()
        if darkModeOn {
            view.backgroundColor = UIColor.darkGrayView
            for label in labels {
                label.textColor = .white
            }
            shareButton.backgroundColor = UIColor.darkInTune
        }
    }

    // MARK: - Actions

    @IBAction func shareButtonPressed(_ sender: Any) {
        let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/pitch-tuner-app-for-iphone/id1169667039?ls=1&mt=8")
        
        UIApplication.shared.open(appStoreUrl!, options: [:], completionHandler: { _ in
            Answers.logCustomEvent(withName: "App Store Review", customAttributes: nil)
            UserDefaults.standard.userDidShareFromAnalytics()
            self.delegate?.userDidShare()
        })
    }
}
