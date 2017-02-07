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
    func userCancelledShare()
    func userDidShare()
}

class ShareViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Variables
    
    var delegate: ShareViewControllerDelegate?
    
    // MARK: - Setup Views

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
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
            cancelButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    // MARK: - Actions

    @IBAction func shareButtonPressed(_ sender: Any) {
        let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/pitch-tuner-app-for-iphone/id1169667039?ls=1&mt=8")
        
        UIApplication.shared.open(appStoreUrl!, options: [:], completionHandler: { _ in
            self.dismiss(animated: true, completion: { _ in
                Answers.logCustomEvent(withName: "App Store Review", customAttributes: nil)
                UserDefaults.standard.userDidShareFromAnalytics()
                self.delegate?.userDidShare()
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Answers.logCustomEvent(withName: "Cancel App Store Review", customAttributes: nil)
        self.dismiss(animated: true, completion: { _ in
            self.delegate?.userCancelledShare()
        })
    }
    
    // MARK: - Status Bar Style
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
